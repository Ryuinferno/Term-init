#!/system/bin/sh
#Script to enable init.d by Ryuinferno @ XDA 2012

echo "Init.d Enabler by Ryuinferno @ XDA 2012"
sleep 2
echo "Have you installed busybox with proper applets? (yes=any number/no=2):"
read ins

if [ $ins -eq 2 ]
then
echo "Please install busybox with proper applets first before attempting this...thank you...=)"
exit
fi
sleep 2
echo "Great! Let's proceed..."
sleep 2
echo "Mounting system as rewritable..."
busybox mount -o remount,rw -t auto /system
sleep 2
echo "Checking for the presence of install-recovery.sh..."
sleep 2
if [ -e /system/etc/install-recovery.sh ] 
then
echo "Install-recovery.sh found, adding lines to it..."
echo "# init.d support" >> /system/etc/install-recovery.sh
echo "run-parts /system/etc/init.d/" >> /system/etc/install-recovery.sh
echo "" >> /system/etc/install-recovery.sh
awk '!x[$0]++' /system/etc/install-recovery.sh > /sdcard/install-recovery.sh
cat /sdcard/install-recovery.sh > /system/etc/install-recovery.sh
echo "" >> /system/etc/install-recovery.sh
rm /sdcard/install-recovery.sh
else
echo "Install-recovery.sh not found, creating the file..."
echo "#!/system/bin/sh" > /system/etc/install-recovery.sh
echo "# init.d support" >> /system/etc/install-recovery.sh
echo "run-parts /system/etc/init.d/" >> /system/etc/install-recovery.sh
echo "" >> /system/etc/install-recovery.sh
fi
sleep 2
echo "Setting the correct permissions and ownership for install-recovery.sh..."
chmod 755 /system/etc/install-recovery.sh
chown 0.0 /system/etc/install-recovery.sh
sleep 2
echo "Checking for the presence of the init.d folder..."
if [ -e /system/etc/init.d ]
then
echo "Init.d folder found..."
else 
echo "Init.d folder not found, creating the folder..."
mkdir /system/etc/init.d
fi
sleep 2
echo "Creating basic init.d scripts..."
echo "#!/system/bin/sh" > /system/etc/init.d/08setperm
echo "#Script to set correct permissions to /system/etc/init.d folder by Ryuinferno @ XDA 2012" >> /system/etc/init.d/08setperm
echo "busybox mount -o remount,rw -t auto /system;" >> /system/etc/init.d/08setperm
echo "busybox chmod -R 777 /system/etc/init.d;" >> /system/etc/init.d/08setperm
echo "" >> /system/etc/init.d/08setperm

echo "#!/system/bin/sh" > /system/etc/init.d/00test
echo "#Init.d Test" >> /system/etc/init.d/00test
echo "busybox mount -o remount,rw -t auto /system" >> /system/etc/init.d/00test
echo "busybox mount -o remount,rw -t auto /data" >> /system/etc/init.d/00test
echo "" >> /system/etc/init.d/00test
echo "if [ -e /data/Test.log ]; then" >> /system/etc/init.d/00test
echo "rm /data/Test.log" >> /system/etc/init.d/00test
echo "fi" >> /system/etc/init.d/00test
echo "" >> /system/etc/init.d/00test
echo "echo  "Ryuinferno @ XDA 2012" > /data/Test.log" >> /system/etc/init.d/00test
echo "echo  "Init.d is working !!!" >> /data/Test.log" >> /system/etc/init.d/00test
echo "" >> /system/etc/init.d/00test
sleep 2
echo "Setting correct permissions and ownership for init.d folder..."
chmod 777 /system/etc/init.d/08setperm
chmod 777 /system/etc/init.d/00test
chown 0.0 /system/etc/init.d
chown 0.0 /system/etc/init.d/08setperm
chown 0.0 /system/etc/init.d/00test
sleep 2
echo "Checking for the presence of sysint in /system/bin..."
sleep 2
if [ -e /system/bin/sysint ]
then
echo "Sysint found, adding lines to it..."
echo "#!/system/bin/sh" >> /system/bin/sysint
echo "# init.d support" >> /system/bin/sysint
echo "" >> /system/bin/sysint
echo "export PATH=/sbin:/system/sbin:/system/bin:/system/xbin" >> /system/bin/sysint
echo "/system/bin/logwrapper run-parts /system/etc/init.d" >> /system/bin/sysint 
echo "" >> /system/bin/sysint
awk '!x[$0]++' /system/bin/sysint > /sdcard/sysint
cat /sdcard/sysint > /system/bin/sysint
echo "" >> /system/bin/sysint
rm /sdcard/sysint
else
echo "Sysint not found, creating file..."
echo "#!/system/bin/sh" > /system/bin/sysint
echo "# init.d support" >> /system/bin/sysint
echo "" >> /system/bin/sysint
echo "export PATH=/sbin:/system/sbin:/system/bin:/system/xbin" >> /system/bin/sysint
echo "/system/bin/logwrapper run-parts /system/etc/init.d" >> /system/bin/sysint 
echo "" >> /system/bin/sysint
fi
sleep 2
echo "Setting correct permissions and ownership for sysint..."
chmod 755 /system/bin/sysint
chown 0.2000 /system/bin/sysint
sleep 2
echo "Done!!!"
sleep 2
echo "Please reboot at least twice before checking /data..."
sleep 2
echo "If init.d is working, you will see a Test.log in /data..."
sleep 2
echo "Enjoy!!! =)"
sleep 2
echo "Ryuinferno @ XDA 2012"
