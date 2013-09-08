#!/system/bin/sh
#Script to enable init.d by Ryuinferno @ XDA

error_msg(){
echo "You do not need this mod..."
sleep 1
echo "If you are reapplying, please delete these files if present:"
echo "/system/bin/sysinit"
sleep 1
echo "/system/etc/install-recovery.sh"
sleep 1
echo "/system/etc/install-recovery-2.sh"
sleep 1
echo "And run again..."
sleep 1
echo "If init.d is still not working, read the FAQ part in my thread..."
sleep 1
echo "Aborting..."
mount -o remount,ro -t auto /system
echo ""
echo "Ryuinferno @ XDA"
exit 1
}

echo "Init.d Enabler by Ryuinferno @ XDA"
echo ""
sleep 1

id=`id`; 
id=`echo ${id#*=}`; 
id=`echo ${id%%\(*}`; 
id=`echo ${id%% *}`
if [ "$id" != "0" ] && [ "$id" != "root" ]; then
	echo "Script NOT running as root!"
	sleep 1
	echo "Superuser access not granted!"
	sleep 1
	echo "Please type 'su' first before running this script..."
	exit 1
else
	echo "Hello Supaa User! :P"
	echo ""
	sleep 1
fi

if [ ! "'which busybox'" ]; then
	echo "busybox NOT INSTALLED!"
	sleep 1
	echo "Please install busybox first!"
	exit 1
else
	echo "busybox found!"
	sleep 1
fi

bbb=0

if [ ! "`which grep`" ]; then 
	bbb=1
	echo "grep applet NOT FOUND!"
	sleep 1
	else 
	echo "Awesome! grep found! :D"
	sleep 1
fi

if [ ! "`which run-parts`" ]; then 
	bbb=1
	echo "run-parts applet NOT FOUND!"
	sleep 1
	else
	echo "Good! run-parts found! :)"
	echo ""
	sleep 1
fi

if [ $bbb -eq 1 ] ; then
	echo ""
	echo "Required applets are NOT FOUND!"
	echo ""
	sleep 1
	echo "Please reinstall busybox!"
	exit 1
fi

echo "Great! Let's proceed..."
echo ""
sleep 1
echo "Press enter to continue..."
read enterKey

clear
sleep 1
echo "Mounting system as rewritable..."
mount -o remount,rw -t auto /system

sleep 1
echo ""
echo "Checking for the presence of sysinit in /system/bin..."
sleep 1
if [ -e /system/bin/sysinit ]; then
	echo "sysinit found..."
	if [ -z "`cat /system/bin/sysinit | grep "init.d"`" ]; then
		echo "Adding lines to sysinit..."
		echo "" >> /system/bin/sysinit
		echo "# init.d support" >> /system/bin/sysinit
		echo "" >> /system/bin/sysinit
		echo "export PATH=/sbin:/system/sbin:/system/bin:/system/xbin" >> /system/bin/sysinit
		echo "run-parts /system/etc/init.d" >> /system/bin/sysinit 
		echo "" >> /system/bin/sysinit
	else
		echo ""
		echo "Your sysinit should already be running the scripts in init.d folder at boot..."
		error_msg
	fi
else
	echo "sysinit not found, creating file..."
	echo "#!/system/bin/sh" > /system/bin/sysinit
	echo "# init.d support" >> /system/bin/sysinit
	echo "" >> /system/bin/sysinit
	echo "export PATH=/sbin:/system/sbin:/system/bin:/system/xbin" >> /system/bin/sysinit
	echo "run-parts /system/etc/init.d" >> /system/bin/sysinit 
	echo "" >> /system/bin/sysinit
fi

sleep 1
echo "Setting correct permissions and ownership for sysinit..."
chmod 755 /system/bin/sysinit
chown 0.2000 /system/bin/sysinit

sleep 1
echo ""
echo "Checking for the presence of install-recovery.sh..."
sleep 1
if [ -f /system/etc/install-recovery.sh ] && [ -z "`cat /system/etc/install-recovery.sh | grep "daemon"`" ]; then
	if [ ! -z "`cat /system/etc/install-recovery.sh | grep "init.d"`" ];then
		echo "Your install-recovery.sh seems to be already modified for init.d..."
		error_msg
	fi
	echo "install-recovery.sh found, renaming it as install-recovery-2.sh..."
	mv /system/etc/install-recovery.sh /system/etc/install-recovery-2.sh
	echo "Recreating install-recovery.sh..."
	echo "#!/system/bin/sh" > /system/etc/install-recovery.sh
	echo "# init.d support" >> /system/etc/install-recovery.sh
	echo "" >> /system/etc/install-recovery.sh
	echo "/system/bin/sysinit" >> /system/etc/install-recovery.sh
	echo "" >> /system/etc/install-recovery.sh
	echo "# excecuting extra commands" >> /system/etc/install-recovery.sh
	echo "/system/etc/install-recovery-2.sh" >> /system/etc/install-recovery.sh
	echo "" >> /system/etc/install-recovery.sh
elif [ -f /system/etc/install-recovery.sh ] && [ ! -z "`cat /system/etc/install-recovery.sh | grep "daemon"`" ]; then
	if [ -f /system/etc/install-recovery-2.sh ] && [ ! -z "`cat /system/etc/install-recovery-2.sh | grep "init.d"`" ];then
		echo "Your install-recovery-2.sh seems to be already modified for init.d..."
		error_msg
	fi
	echo "install-recovery.sh is used for superuser, using install-recovery-2.sh instead..."
	if [ -f /system/etc/install-recovery-2.sh ]; then
		echo "" >> /system/etc/install-recovery-2.sh
		echo "# init.d support" >> /system/etc/install-recovery-2.sh
		echo "/system/bin/sysinit" >> /system/etc/install-recovery-2.sh
		echo "" >> /system/etc/install-recovery-2.sh
	else
		echo "#!/system/bin/sh" > /system/etc/install-recovery-2.sh
		echo "# init.d support" >> /system/etc/install-recovery-2.sh
		echo "" >> /system/etc/install-recovery-2.sh
		echo "/system/bin/sysinit" >> /system/etc/install-recovery-2.sh
		echo "" >> /system/etc/install-recovery-2.sh
	fi
	if [ -z "`cat /system/etc/install-recovery.sh | grep "install-recovery-2.sh"`" ]; then
		echo "" >> /system/etc/install-recovery.sh
		echo "# extra commands" >> /system/etc/install-recovery.sh
		echo "/system/etc/install-recovery-2.sh" >> /system/etc/install-recovery.sh
		echo "" >> /system/etc/install-recovery.sh
	fi
else
	echo "install-recovery.sh not found, creating it..."
	echo "#!/system/bin/sh" > /system/etc/install-recovery.sh
	echo "# init.d support" >> /system/etc/install-recovery.sh
	echo "" >> /system/etc/install-recovery.sh
	echo "/system/bin/sysinit" >> /system/etc/install-recovery.sh
	echo "" >> /system/etc/install-recovery.sh
fi

sleep 1
echo "Setting the correct permissions and ownership for install-recovery.sh..."
echo "Also for install-recovery-2.sh if it exists..."
chmod 755 /system/etc/install-recovery.sh
chown 0.0 /system/etc/install-recovery.sh
if [ -f /system/etc/install-recovery-2.sh ]; then
	chmod 755 /system/etc/install-recovery-2.sh
	chown 0.0 /system/etc/install-recovery-2.sh
fi

sleep 1
echo ""
echo "Checking for the presence of the init.d folder..."
sleep 1
if [ -d /system/etc/init.d ]; then
	echo "init.d folder found..."
else 
	echo "init.d folder not found, creating the folder..."
	mkdir /system/etc/init.d
fi

sleep 1
echo ""
echo "Creating basic init.d scripts..."
echo "#!/system/bin/sh" > /system/etc/init.d/08setperm
echo "#set correct permissions to /system/etc/init.d folder" >> /system/etc/init.d/08setperm
echo "" >> /system/etc/init.d/08setperm
echo "mount -o remount,rw -t auto /system" >> /system/etc/init.d/08setperm
echo "chmod -R 777 /system/etc/init.d" >> /system/etc/init.d/08setperm
echo "mount -o remount,ro -t auto /system" >> /system/etc/init.d/08setperm
echo "" >> /system/etc/init.d/08setperm

echo "#!/system/bin/sh" > /system/etc/init.d/00test
echo "#init.d test" >> /system/etc/init.d/00test
echo "" >> /system/etc/init.d/00test
echo "if [ -f /data/Test.log ]; then" >> /system/etc/init.d/00test
echo "rm /data/Test.log" >> /system/etc/init.d/00test
echo "fi" >> /system/etc/init.d/00test
echo "" >> /system/etc/init.d/00test
echo 'echo "Init.d is working !!!" >> /data/Test.log' >> /system/etc/init.d/00test
echo 'echo "excecuted on $(date +"%d-%m-%Y %r" )" >> /data/Test.log' >> /system/etc/init.d/00test
echo "" >> /system/etc/init.d/00test

sleep 1
echo "Setting correct permissions and ownership for init.d folder and scipts..."
chmod 777 /system/etc/init.d
chmod 777 /system/etc/init.d/08setperm
chmod 777 /system/etc/init.d/00test
chown 0.0 /system/etc/init.d
chown 0.0 /system/etc/init.d/08setperm
chown 0.0 /system/etc/init.d/00test

sleep 1
echo ""
echo "Mounting system as read-only..."
mount -o remount,ro -t auto /system
sleep 1
echo ""
echo "Done!!!"
sleep 1
echo "Please reboot at least twice before checking /data..."
sleep 1
echo "If init.d is working, you will see a Test.log in /data..."
sleep 1
echo ""
echo "Enjoy!!! =)"
echo "Ryuinferno @ XDA 2013"
exit
