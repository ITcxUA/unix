
##==================== ≠≠≠ ====================##
##================ Pre Install ================##
##==================== ≠≠≠ ====================##
## Выполнение скрипта перед установкой:

%pre --interpreter /usr/bin/python
#!/bin/sh


# assumes all disks for install are on the scsi bus
echo "pre kickstart script is running" > /tmp/pre-kickstart.out
#echo "pre kickstart script is running" > .\pre-kickstart.out
#				path for file
outfile='/tmp/part-include'


##==================== ≠≠≠ ====================##
## For IDE HDD  !!!notSATA!!! 
hds=""
mymedia=""
for file in /proc/ide/h* do
	mymedia=`cat $file/media`
	if [ $mymedia == "disk" ] ; then
		hds="$hds `basename $file`"
	fi
done
set $hds
numhd=`echo $#`  
drive1=`echo $hds | cut -d' ' -f1`
drive2=`echo $hds | cut -d' ' -f2`

#Write out partition scheme based on whether there are 1 or 2 hard drives  
if [ $numhd == "2" ] ; then
	
	#======partitioning %pre for 2 drives ==========#
	echo 'clearpart --all' > /tmp/part-include
	echo 'part biosboot --fstype=biosboot --size=2 --ondisk=sda' > /tmp/part-include
	echo 'part /boot --fstype=ext4 --size=1022 --label=BOOT --ondisk=sda' > /tmp/part-include
	echo 'part swap --fstype=swap --size=8196 --ondisk=sda' > /tmp/part-include
	echo 'part / --fstype=ext4 --size=111700 --grow --ondisk=sda' > /tmp/part-include
	echo 'part /home --fstype=ext4 --size=184320 --grow --ondisk=sdg' > /tmp/part-include
	
	END
else
	#======partitioning %pre for 1 drives ==========#

	echo 'clearpart --all' > /tmp/part-include
	echo 'part biosboot --fstype=biosboot --size=2 --ondisk=sda' > /tmp/part-include
	echo 'part /boot --fstype=ext4 --size=1022 --ondisk=sda' > /tmp/part-include
	echo 'part swap --fstype=swap --size=8196' > /tmp/part-include
	echo 'part /  --fstype=xfs --size=111700 --label=ROOT --grow' > /tmp/part-include
	echo 'part /home  --fstype=xfs --size=184320 --label=HOME --grow' > /tmp/part-include

	END
fi

##==================== ≠≠≠ ====================##


%include "$outfile"

%end

