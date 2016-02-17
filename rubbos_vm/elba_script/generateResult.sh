#!/bin/bash
#cd /mnt/sdc/qywang/rubbosResult/scripts
source set_elba_env.sh
#cd -

cd $BONN_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME


#generate results
cp /mnt/sdc/qywang/rubbosResult/scripts/extract-results_BO.prl ./
cp /mnt/sdc/qywang/rubbosResult/scripts/create-sarExcel_newSarFormat.prl ./
cp /mnt/sdc/qywang/rubbosResult/scripts/Experiments_finegrainedCPU_extract.py ./
cp /mnt/sdc/qywang/rubbosResult/scripts/Experiments_runtime_extract.py ./
cp /mnt/sdc/qywang/rubbosResult/scripts/oprofileExtract.py ./
cp /mnt/sdc/qywang/rubbosResult/scripts/sarResourceUtilExtractAve.py ./
cp /mnt/sdc/qywang/rubbosResult/scripts/javaGCextraction.py ./
cp /mnt/sdc/qywang/rubbosResult/scripts/dataPreparation*.py ./
cp /mnt/sdc/qywang/rubbosResult/scripts/extract_longReq_clientSide.py ./
cp /mnt/sdc/qywang/rubbosResult/scripts/extract_rubbos_results2.py ./
cp /mnt/sdc/qywang/rubbosResult/scripts/Experiments_files_AddworkloadPrefix.py ./
cp /mnt/sdc/qywang/rubbosResult/scripts/Experiments_esxtopProcessing.py ./
cp /mnt/sdc/qywang/rubbosResult/scripts/PowerDataFiltering.py ./
cp /mnt/sdc/qywang/rubbosResult/scripts/PowerExtraction.py ./
cp /mnt/sdc/qywang/rubbosResult/scripts/collectl*.py ./
cp /mnt/sdc/qywang/rubbosResult/scripts/parser.sh ./
cp /mnt/sdc/qywang/rubbosResult/scripts/chienAn_parser_Trace.py ./

./extract-results_BO.prl > TPRS.csv
./create-sarExcel_newSarFormat.prl

gunzip */zipkin*.gz

python Experiments_finegrainedCPU_extract.py
python Experiments_runtime_extract.py
python oprofileExtract.py
python dataPreparationControl.py $BONN_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME/set_elba_env.sh
python sarResourceUtilExtractAve.py
python javaGCextraction.py
python extract_longReq_clientSide.py
python extract_rubbos_results2.py

python chienAn_parser_Trace.py
python Experiments_files_AddworkloadPrefix.py
python Experiments_esxtopProcessing.py
python PowerDataFiltering.py
python PowerExtraction.py
python collectlExtract.py
python collectlResultFilter.py


chmod +x protoToprotoFiltering.sh
