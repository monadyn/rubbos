#!/bin/bash

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# Modify these two lines adapt to your environment
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
MULINI_DIR=/home/qywang/rubbos/rubbosMulini6
#OUTPUT_HOME=/home/qywang/rubbos/RUBBOS-XTBL-Plus1-2-1MH-First-QYW-SYSA-moreClients
OUTPUT_HOME=/home/qywang/rubbos/RUBBOS-XTBL-Plus1-1-1-1MH-Test2015Demo
#OUTPUT_HOME=/home/qywang/rubbos/test
#OUTPUT_HOME=/net/hu3/qywang/elbaworkspace/rubbos/Qingyang_1_1_1_3MH_First_1113_TM_co-ForSimon

INPUT_XTBL_PLUS=$1
INPUT_MAIN_TEMPLATE=$MULINI_DIR/templates/DeployScript/MainRun2.xsl
#DEP_TEMPLATE=/proj/Infosphere/linqf/hp_project/elba/rubisMulini-jae/templates/DeployScript/Dep.xsl

JAVAPATH=/home/qywang/j2sdk1.4.2_04

mkdir -p $OUTPUT_HOME

cd $MULINI_DIR/source

# remove the temporary xml outputs from previous run
# to prevent Permission Denied error
rm -f dsgOutput.xml tempDsgOutput.xml


# run Mulini with appropriate XTBL-Plus xml file and main template stylesheet file
# to generate all the deployment scripts
$JAVAPATH/bin/java -classpath $JAVAPATH/jre/lib/rt.jar:./ DeployScriptGenerator ../$INPUT_XTBL_PLUS $INPUT_MAIN_TEMPLATE
#$JAVAPATH/bin/java -classpath $JAVAPATH/jre/lib/rt.jar:./ Dep $INPUT_XTBL_PLUS $DEP_TEMPLATE

# copy the XTBL file into $OUTPUT_HOME
cp ../$1 $OUTPUT_HOME/

# run "run.sh" to start the rubis experiment
cd $OUTPUT_HOME/scripts
chmod 755 *.sh
#./run.sh
