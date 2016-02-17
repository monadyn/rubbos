<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='control_server' and @actype='emulabConf_exec' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='control_server' and @actype='emulabConf_exec' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='control_server' and @actype='emulabConf_exec' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/emulab_config.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

# Make and mount new partiton
echo "*** make FS on a partition and mount it *************************"

for i in<xsl:for-each select="//instances/instance[contains(@type,'_server') and @type!='control_server']"><!--
  --> "$<xsl:value-of select="@name"/>_HOST"</xsl:for-each>
do
ssh $i "
  sudo mkdir -p $ELBA_TOP
  sudo chmod 777 $ELBA_TOP
"
scp $WORK_HOME/emulab_files/limits.conf $i:$ELBA_TOP
scp $WORK_HOME/emulab_files/login $i:$ELBA_TOP
scp $WORK_HOME/emulab_files/file-max $i:$ELBA_TOP

ssh $i "
  sudo mv $ELBA_TOP/limits.conf /etc/security/
  sudo mv $ELBA_TOP/login  /etc/pam.d/
"
done


<xsl:if test="//instances/instance[contains(@type,'_server') and @type!='control_server' and
          not(./target/@type='pc600')]">
for i in<xsl:for-each select="//instances/instance[contains(@type,'_server') and
                        @type!='control_server' and not(./target/@type='pc600')]"><!--
  --> "$<xsl:value-of select="@name"/>_HOST"</xsl:for-each>
do
  ssh $i "
    sudo mkdir -p $ELBA_TOP
    echo -e \"t\n4\n83\nw\" | sudo /sbin/fdisk /dev/sda
    sudo reboot
  " &amp;
done
</xsl:if>
<xsl:if test="//instances/instance[contains(@type,'_server') and @type!='control_server' and
          ./target/@type='pc600']">
for i in<xsl:for-each select="//instances/instance[contains(@type,'_server') and
                        @type!='control_server' and ./target/@type='pc600']"><!--
  --> "$<xsl:value-of select="@name"/>_HOST"</xsl:for-each>
do
  ssh $i "
    sudo mkdir -p $ELBA_TOP
    echo -e \"t\n4\n83\nw\" | sudo /sbin/fdisk /dev/hda
    sudo reboot
  " &amp;
done
</xsl:if>
echo "sleep 480"
sleep 480
echo "wake up from sleeping 480"

<xsl:if test="//instances/instance[contains(@type,'_server') and @type!='control_server' and
          not(./target/@type='pc600')]">
for i in<xsl:for-each select="//instances/instance[contains(@type,'_server') and
                        @type!='control_server' and not(./target/@type='pc600')]"><!--
  --> "$<xsl:value-of select="@name"/>_HOST"</xsl:for-each>
do
  ssh $i "
   sudo /sbin/mkfs /dev/sda4 
   sudo mount /dev/sda4 $ELBA_TOP 
   sudo chmod 777 $ELBA_TOP
   mkdir -p $RUBBOS_TOP
   sudo cp $SOFTWARE_HOME/sdparm-1.03.tgz /tmp
   cd /tmp
   sudo tar -zxvf ./sdparm-1.03.tgz
   cd sdparm-1.03
   sudo ./configure
   sudo make
   sudo make install
   sudo sdparm -c WCE /dev/sda
  " &amp;
done
</xsl:if>
<xsl:if test="//instances/instance[contains(@type,'_server') and @type!='control_server' and
          ./target/@type='pc600']">
for i in<xsl:for-each select="//instances/instance[contains(@type,'_server') and
                        @type!='control_server' and ./target/@type='pc600']"><!--
  --> "$<xsl:value-of select="@name"/>_HOST"</xsl:for-each>
do
  ssh $i "
   sudo /sbin/mkfs /dev/hda4 
   sudo mount /dev/hda4 $ELBA_TOP 
   sudo chmod 777 $ELBA_TOP
   mkdir -p $RUBBOS_TOP
  " &amp;
done
</xsl:if>
echo "sleep 420"
sleep 420
echo "wake up from sleeping 420"

</xsl:template>
</xsl:stylesheet>















