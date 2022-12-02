#!/bin/bash

############################################################################################################
# Download bacteria, archaea, and eukaryota genomes from NCBI RefSeq and GenBank
############################################################################################################
working_dir=/home/tianqi/project/DeepMicrobeFinder/data

cd $working_dir

if [ ! -f "genome_updater.sh" ]; then
    wget --quiet --show-progress https://raw.githubusercontent.com/pirovc/genome_updater/master/genome_updater.sh
    chmod +x genome_updater.sh
fi
./genome_updater.sh -d "refseq,genbank" -l "complete genome" -f "genomic.fna.gz" -t 12 -o "sequence/pre20_archaea" -T '2157' -E 20191230 -R 10 
./genome_updater.sh -d "refseq,genbank" -l "complete genome" -f "genomic.fna.gz" -t 12 -o "sequence/post20_archaea" -T '2157' -D 20200101 -R 10 
./genome_updater.sh -d "refseq" -l "complete genome" -f "genomic.fna.gz" -t 12 -o "sequence/pre20_bacteria" -T '2' -E 20191230 -R 10 
./genome_updater.sh -d "refseq" -l "complete genome" -f "genomic.fna.gz" -t 12 -o "sequence/post20_bacteria" -T '2' -D 20200101 -R 10 

./genome_updater.sh -d "refseq,genbank" -f "genomic.fna.gz" -t 12 -o "sequence/pre20_eukaryote" -E 20191230 -T '554915,554296,3027,33682,33634,33630,543769,260810,5752,2611341,2763,3041,38254' -R 10 -l "complete genome"
./genome_updater.sh -d "refseq,genbank" -f "genomic.fna.gz" -t 12 -o "sequence/post20_eukaryote" -D 20200101 -T '554915,554296,3027,33682,33634,33630,543769,260810,5752,2611341,2763,3041,38254' -R 10 -l "complete genome"

############################################################################################################
# Download virus-host db
############################################################################################################
vhdb_dir=/home/tianqi/dataset/virus-host-db
cd $vhdb_dir
wget -q --show-progress https://www.genome.jp/ftp/db/virushostdb/virushostdb.formatted.genomic.fna.gz
wget -q --show-progress https://www.genome.jp/ftp/db/virushostdb/virushostdb.tsv
gzip -d virushostdb.formatted.genomic.fna.gz

############################################################################################################
# Download PLSDB
############################################################################################################
plsdb_dir=/home/tianqi/dataset/plsdb
cd $plsdb_dir
wget -q --show-progress https://ccb-microbe.cs.uni-saarland.de/plsdb/plasmids/download/plasmids_meta.tar.bz2
wget -q --show-progress https://ccb-microbe.cs.uni-saarland.de/plsdb/plasmids/download/plsdb.fna.bz2
tar -xjf plasmids_meta.tar.bz2
bzip2 -d plsdb.fna.bz2

############################################################################################################
# Download MMETSP
############################################################################################################
mmetsp_dir=/home/tianqi/dataset/MMETSP
cd $mmetsp_dir
zenodo_id=1212585
zenodo_get -R 32 $zenodo_id

############################################################################################################
# Download IMG/VR v4
############################################################################################################
img_dir=/home/tianqi/dataset/img
cd $img_dir
curl 'https://signon.jgi.doe.gov/signon/create' --data-urlencode 'login=email' --data-urlencode 'password=pass' -c cookies > /dev/null
curl 'https://genome.jgi.doe.gov/portal/ext-api/downloads/get_tape_file?blocking=true&url=/IMG_VR/download/_JAMO/632a3d7d2de7c323533dac10/README-high_confidence.txt' -b cookies > README-high_confidence.txt
curl 'https://genome.jgi.doe.gov/portal/ext-api/downloads/get_tape_file?blocking=true&url=/IMG_VR/download/_JAMO/632a3d7d2de7c323533dac0a/IMGVR_all_proteins-high_confidence.faa.gz' -b cookies > IMGVR_all_proteins.faa.gz
curl 'https://genome.jgi.doe.gov/portal/ext-api/downloads/get_tape_file?blocking=true&url=/IMG_VR/download/_JAMO/632a3d7d2de7c323533dac08/IMGVR_all_nucleotides-high_confidence.fna.gz' -b cookies > IMGVR_all_nucleotides.fna.gz
curl 'https://genome.jgi.doe.gov/portal/ext-api/downloads/get_tape_file?blocking=true&url=/IMG_VR/download/_JAMO/632a3d7d2de7c323533dac0c/IMGVR_all_Sequence_information-high_confidence.tsv' -b cookies > IMGVR_all_Sequence_information.tsv
curl 'https://genome.jgi.doe.gov/portal/ext-api/downloads/get_tape_file?blocking=true&url=/IMG_VR/download/_JAMO/632a3d7d2de7c323533dac0e/IMGVR_all_Host_information-high_confidence.tsv' -b cookies > IMGVR_all_Host_information.tsv