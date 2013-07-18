#!/system/bin/sh
#Script to enable init.d by Ryuinferno @ XDA 2013

echo "Init.d Enabler by Ryuinferno @ XDA 2012"
echo ""
sleep 2

id=`id`; 
id=`echo ${id#*=}`; 
id=`echo ${id%%\(*}`; 
id=`echo ${id%% *}`
if [ "$id" != "0" ] && [ "$id" != "root" ]; then
	echo "Script NOT running as root!"
	sleep 2
	echo "SuperUser access not granted!"
	sleep 2
	echo "Please type 'su' first before running this script..."
	exit
else
	echo "Hello Supaa User! :P"
	echo ""
	sleep 2
fi

if [ ! "'which busybox'" ]; then
	echo "busybox NOT INSTALLED!"
	sleep 2
	echo "Please install busybox first!"
	exit
else
	echo "busybox found!"
	sleep 2
fi

bbb=0

if [ ! "`which awk`" ]; then 
	bbb=1
	echo "awk applet NOT FOUND!"
	sleep 2
	else 
	echo "Awesome! awk found! :D"
	sleep 2
fi

if [ ! "`which run-parts`" ]; then 
	bbb=1
	echo "run-parts applet NOT FOUND!"
	sleep 2
	else
	echo "Good! run-parts found! :)"
	echo ""
	sleep 2
fi

if [ $bbb -eq 1 ] ; then
	echo ""
	echo "Required applets are NOT FOUND!"
	echo ""
	sleep 2
	echo "Please reinstall busybox!"
	exit
fi

echo "Great! Let's proceed..."
echo ""
sleep 1
echo "Press enter to continue..."
read enterKey

clear
sleep 2
echo "Mounting system as rewritable..."
echo ""
busybox mount -o remount,rw -t auto /system

sleep 2
echo "Checking for the presence of install-recovery.sh..."
sleep 2
if [ -e /system/etc/install-recovery.sh ]; then
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
echo ""
chmod 755 /system/etc/install-recovery.sh
chown 0.0 /system/etc/install-recovery.sh

sleep 2
echo "Checking for the presence of the init.d folder..."
sleep 2
if [ -e /system/etc/init.d ]; then
	echo "Init.d folder found..."
else 
	echo "Init.d folder not found, creating the folder..."
	mkdir /system/etc/init.d
fi

sleep 2
echo "Creating basic init.d scripts..."
echo "#!/system/bin/sh" > /system/etc/init.d/08setperm
echo "#Script to set correct permissions to /system/etc/init.d folder by Ryuinferno @ XDA 2013" >> /system/etc/init.d/08setperm
echo "" >> /system/etc/init.d/08setperm
echo "busybox mount -o remount,rw -t auto /system;" >> /system/etc/init.d/08setperm
echo "busybox chmod -R 777 /system/etc/init.d;" >> /system/etc/init.d/08setperm
echo "busybox mount -o remount,ro -t auto /system;" >> /system/etc/init.d/08setperm
echo "" >> /system/etc/init.d/08setperm

echo "#!/system/bin/sh" > /system/etc/init.d/00test
echo "#Init.d Test" >> /system/etc/init.d/00test
echo "" >> /system/etc/init.d/00test
echo "if [ -e /data/Test.log ]; then" >> /system/etc/init.d/00test
echo "rm /data/Test.log" >> /system/etc/init.d/00test
echo "fi" >> /system/etc/init.d/00test
echo "" >> /system/etc/init.d/00test
echo 'echo "Ryuinferno @ XDA 2013" > /data/Test.log' >> /system/etc/init.d/00test
echo 'echo "Init.d is working !!!" >> /data/Test.log' >> /system/etc/init.d/00test
echo 'echo "excecuted on $(date +"%d-%m-%Y %r" )" >> /data/Test.log' >> /system/etc/init.d/00test
echo "" >> /system/etc/init.d/00test

sleep 2
echo "Setting correct permissions and ownership for init.d folder..."
echo ""
chmod 777 /system/etc/init.d/08setperm
chmod 777 /system/etc/init.d/00test
chown 0.0 /system/etc/init.d
chown 0.0 /system/etc/init.d/08setperm
chown 0.0 /system/etc/init.d/00test

sleep 2
echo "Checking for the presence of sysinit in /system/bin..."
sleep 2
if [ -e /system/bin/sysinit ]; then
	echo "Sysinit found, adding lines to it..."
	echo "#!/system/bin/sh" >> /system/bin/sysinit
	echo "# init.d support" >> /system/bin/sysinit
	echo "" >> /system/bin/sysinit
	echo "export PATH=/sbin:/system/sbin:/system/bin:/system/xbin" >> /system/bin/sysinit
	echo "/system/bin/logwrapper run-parts /system/etc/init.d" >> /system/bin/sysinit 
	echo "" >> /system/bin/sysinit
	awk '!x[$0]++' /system/bin/sysinit > /sdcard/sysinit
	cat /sdcard/sysinit > /system/bin/sysinit
	echo "" >> /system/bin/sysinit
	rm /sdcard/sysinit
else
	echo "Sysinit not found, creating file..."
	echo "#!/system/bin/sh" > /system/bin/sysinit
	echo "# init.d support" >> /system/bin/sysinit
	echo "" >> /system/bin/sysinit
	echo "export PATH=/sbin:/system/sbin:/system/bin:/system/xbin" >> /system/bin/sysinit
	echo "/system/bin/logwrapper run-parts /system/etc/init.d" >> /system/bin/sysinit 
	echo "" >> /system/bin/sysinit
fi

sleep 2
echo "Setting correct permissions and ownership for sysinit..."
chmod 755 /system/bin/sysinit
chown 0.2000 /system/bin/sysinit

sleep 2
echo ""
echo "Mounting system as read-only..."
busybox mount -o remount,ro -t auto /system
sleep 2
echo ""
echo "Done!!!"
sleep 2
echo "Please reboot at least twice before checking /data..."
sleep 2
echo "If init.d is working, you will see a Test.log in /data..."
sleep 2
echo ""
echo "Enjoy!!! =)"
sleep 2
echo "Ryuinferno @ XDA 2013"
exit

