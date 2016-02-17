 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

echo "  INSTALLING APACHE on $HOSTNAME"

mkdir -p $ELBA_TOP
chmod 755 $ELBA_TOP
mkdir -p $RUBBOS_TOP
chmod 755 $RUBBOS_TOP

# apache
tar zxf $SOFTWARE_HOME/$HTTPD_TARBALL --directory=$RUBBOS_TOP 
cd $HTTPD_INSTALL_FILES 
#./configure --prefix=$HTTPD_HOME --enable-module=so --enable-so
# --enable-mods-shared=all 
export LDFLAGS="-L/lib64 -L/usr/lib64"
./configure --prefix=$HTTPD_HOME --enable-module=so --enable-so --with-mpm=worker 
make 
make install 

# mod jk
tar zxf $SOFTWARE_HOME/$MOD_JK_TARBALL --directory=$RUBBOS_TOP 
tar zxf $SOFTWARE_HOME/$JAVA_TARBALL --directory=$RUBBOS_TOP
#cd $MOD_JK_INSTALL_FILES/jk/native2
#./configure --with-apxs2=$HTTPD_HOME/bin/apxs --enable-jni --with-java-home=$JAVA_HOME
#make
#make install-apxs 
#cd $MOD_JK_INSTALL_FILES/jk/native
cd $MOD_JK_INSTALL_FILES/native
#./configure --with-apxs=$HTTPD_HOME/bin/apxs --enable-jni --with-java-home=$JAVA_HOME
./configure --with-apxs=$HTTPD_HOME/bin/apxs
make
make install 

echo "  APACHE IS INSTALLED on $HOSTNAME"
 
