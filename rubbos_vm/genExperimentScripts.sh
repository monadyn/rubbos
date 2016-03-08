#!/bin/bash

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# Modify these two lines adapt to your environment
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
MULINI_DIR=$(pwd)
OUTPUT_HOME=$(pwd)/elba_script


INPUT_XTBL_PLUS=$1
INPUT_MAIN_TEMPLATE=$MULINI_DIR/templates/DeployScript/MainRun2.xsl
#DEP_TEMPLATE=/proj/Infosphere/linqf/hp_project/elba/rubisMulini-jae/templates/DeployScript/Dep.xsl

JAVAPATH=/usr
pwdPATH=$(pwd)
EXTENDPATH=$pwdPATH/lib/serializer.jar:$pwdPATH/lib/xalan.jar:/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.85.x86_64/jre/lib/rt.jar:./

mkdir $OUTPUT_HOME

cd $MULINI_DIR/source

# remove the temporary xml outputs from previous run
# to prevent Permission Denied error
rm -f dsgOutput.xml tempDsgOutput.xml


# run Mulini with appropriate XTBL-Plus xml file and main template stylesheet file
# to generate all the deployment scripts
echo $EXTENDPATH



echo $JAVAPATH/bin/java -classpath $EXTENDPATH DeployScriptGenerator $INPUT_XTBL_PLUS $INPUT_MAIN_TEMPLATE
#$JAVAPATH/bin/javac -classpath $EXTENDPATH DeployScriptGenerator
$JAVAPATH/bin/java -classpath $EXTENDPATH DeployScriptGenerator $INPUT_XTBL_PLUS $INPUT_MAIN_TEMPLATE
#$JAVAPATH/bin/java -classpath $JAVAPATH/jre/lib/rt.jar:./ Dep $INPUT_XTBL_PLUS $DEP_TEMPLATE

# copy the XTBL file into $OUTPUT_HOME
cp $1 $OUTPUT_HOME/

# run "run.sh" to start the rubis experiment
cd $OUTPUT_HOME/scripts
chmod 755 *.sh
#./run.sh
