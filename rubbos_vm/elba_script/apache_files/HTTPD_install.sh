 

#!/bin/bash

cd /net/hu3/qywang/elbaworkspace/rubbos/Qingyang_1_2_1_2MH_First
source set_elba_env.sh

echo "  INSTALLING APACHE on $HOSTNAME"

mkdir -p $ELBA_TOP
chmod 755 $ELBA_TOP
mkdir -p $RUBBOS_TOP
chmod 755 $RUBBOS_TOP

# apache
tar zxf $SOFTWARE_HOME/$HTTPD_TARBALL --directory=$RUBBOS_TOP 
cd $HTTPD_INSTALL_FILES 
export LDFLAGS="-L/lib64 -L/usr/lib64"
#./configure --prefix=$HTTPD_HOME --enable-module=so --enable-so
# --enable-mods-shared=all 
./configure --prefix=$HTTPD_HOME --enable-module=so --enable-so --with-mpm=worker
echo "Finish configuring Apache"
make
echo "Finish making Apache"
make install 
echo "Finish installing Apache"
#export LD_LIBRARY_PATH=$HTTPD_HOME/lib:$LD_LIBRARY_PATH

# mod jk
tar zxf $SOFTWARE_HOME/$MOD_JK_TARBALL --directory=$RUBBOS_TOP 
tar zxf $SOFTWARE_HOME/$JAVA_TARBALL --directory=$RUBBOS_TOP
#cd $MOD_JK_INSTALL_FILES/jk/native2
#./configure --with-apxs2=$HTTPD_HOME/bin/apxs --enable-jni --with-java-home=$JAVA_HOME
#make
#make install-apxs 
cd $MOD_JK_INSTALL_FILES/jk/native
#./configure --with-apxs=$HTTPD_HOME/bin/apxs --enable-jni --with-java-home=$JAVA_HOME
./configure --with-apxs=$HTTPD_HOME/bin/apxs --with-apache=$HTTPD_HOME
#/mnt/local_disk/elba/rubbos/apache2/modules
echo "Finish configuring mod_jk"
make
echo "Finish making mod_jk"
make install 
echo "Finish installing mod_jk"

echo "  APACHE IS INSTALLED on $HOSTNAME"
 
