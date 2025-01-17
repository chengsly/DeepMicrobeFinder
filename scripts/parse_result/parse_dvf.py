import numpy as np
import pandas as pd
import os
import re
from sklearn.metrics import f1_score

RESULT_DIR = 'data/result_others/result_dvf'

results_fn = os.listdir(RESULT_DIR)
results_fn.sort()

TARGET_DIR = 'data/sampled_sequence_target'

target_fn = os.listdir(TARGET_DIR)
target_fn.sort()

def construct_result(df):
    result = []
    for i, row in df.iterrows():
        if row['score'] > 0.5:
            result.append(1)
        else:
            result.append(0)
    return np.array(result)

summary_df = pd.DataFrame(columns=['filename', 'f1_score', 'accuracy'])

mistakes = []

accs = []
f1s = []
for f in results_fn:
    result = pd.read_table(os.path.join(RESULT_DIR, f), index_col=0)
    
    index = list(result.index)
    index = [i.split()[0] for i in index]
    result.index = index
    
    target_pkl = pd.read_pickle(os.path.join(TARGET_DIR, f'{f[:-21]}.fa.pkl'))
    target = np.array([target_pkl.loc[i] for i in index]).flatten()

    missed = len(target_pkl) - len(target)
    missed_label = []
    for i in target_pkl.index:
        if i not in result.index:
            missed_label.append(target_pkl.loc[i, 0])
    missed_label = np.array(missed_label).flatten()
    target = np.concatenate((target, missed_label))

    target_binary = np.ones(len(target))
    target_binary[target!=4] = 0

    result = construct_result(result)

    result = np.concatenate((result, np.zeros(missed)))

    try:
        acc = (result==target_binary).sum() / len(target_binary)
        f1 = f1_score(target_binary, result)
    except:
        print(f)

    nums = re.findall(r'\d+', f)[1:-1]
    summary_df = pd.concat([summary_df, pd.DataFrame([['_'.join(nums), f1, acc]], columns=['filename', 'f1_score', 'accuracy'])], axis=0)

    mistake = [(target[result==1]==3).sum(), (target[result==1]==0).sum(), (target[result==1]==1).sum(), (target[result==1]==2).sum(), (target[result==0]==4).sum()] # For prokaryotic virus
    mistakes.append(mistake)

    # print(f)
    # print(f'Acc: {acc}\tF1: {f1}\tUnknown: {(result==-1).sum()/len(result)}')
    # print(acc, end=', ')
    # print(f1, end=', ')
    accs.append(acc)
    f1s.append(f1)
# print(', '.join([str(i) for i in accs]))
# print(', '.join([str(i) for i in f1s]))
summary_df.to_csv('perf_summary/dvf.csv', index=False)

misclassified = pd.DataFrame(mistakes, columns=['Prok->ProkVir', 'Euk->ProkVir', 'EukVir->ProkVir', 'Plas->ProkVir', 'ProkVir->NonProkVir'])
misclassified.to_csv('perf_summary/misclassified_dvf.csv', index=False)