#!/bin/bash

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# Modify these two lines adapt to your environment
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
MULINI_DIR=/proj/Infosphere/yasu/rubbos/rubbosMulini6
OUTPUT_HOME=/proj/Infosphere/yasu/rubbos/Junhee_1_2_1_3ML_FIRST_SarOn


INPUT_XTBL_PLUS=$1
INPUT_MAIN_TEMPLATE=$MULINI_DIR/templates/DeployScript/MainRun2.xsl
#DEP_TEMPLATE=/proj/Infosphere/linqf/hp_project/elba/rubisMulini-jae/templates/DeployScript/Dep.xsl

JAVAPATH=/proj/Infosphere/aniket/Tools/j2sdk/j2sdk1.4.2_04

mkdir $OUTPUT_HOME

cd $MULINI_DIR/source

# remove the temporary xml outputs from previous run
# to prevent Permission Denied error
rm -f dsgOutput.xml tempDsgOutput.xml


# run Mulini with appropriate XTBL-Plus xml file and main template stylesheet file
# to generate all the deployment scripts
$JAVAPATH/bin/java -classpath $JAVAPATH/jre/lib/rt.jar:./ DeployScriptGenerator $INPUT_XTBL_PLUS $INPUT_MAIN_TEMPLATE
#$JAVAPATH/bin/java -classpath $JAVAPATH/jre/lib/rt.jar:./ Dep $INPUT_XTBL_PLUS $DEP_TEMPLATE

# copy the XTBL file into $OUTPUT_HOME
cp $1 $OUTPUT_HOME/

# run "run.sh" to start the rubis experiment
cd $OUTPUT_HOME/scripts
chmod 755 *.sh
#./run.sh
