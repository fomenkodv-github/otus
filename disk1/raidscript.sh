#!/bin/sh

mdadm --zero-superblock /dev/sd[b-e]
sleep 1
mdadm --create /dev/md5 --level=raid5 --raid-devices=4 /dev/sd[b-e]
sleep 2
mdadm --detail --scan > /etc/mdadm.conf
sleep 1
echo -e "g\nn\n1\n\n300000\nn\n2\n\n600000\nn\n3\n\n900000\nn\n4\n\n1200000\nn\n5\n\n\nw" | fdisk /dev/md5
sleep 1
mkfs.ext4 /dev/md5p1
sleep 1
mkfs.ext4 /dev/md5p2
sleep 1
mkfs.ext4 /dev/md5p3
sleep 1
mkfs.ext4 /dev/md5p4
sleep 1
mkfs.ext4 /dev/md5p5
sleep 1
mkdir /mnt/md5p1
mkdir /mnt/md5p2
mkdir /mnt/md5p3
mkdir /mnt/md5p4
mkdir /mnt/md5p5
sleep 1
mount -t auto -v /dev/md5p1 /mnt/md5p1
mount -t auto -v /dev/md5p2 /mnt/md5p2
mount -t auto -v /dev/md5p3 /mnt/md5p3
mount -t auto -v /dev/md5p4 /mnt/md5p4
mount -t auto -v /dev/md5p5 /mnt/md5p5
sleep 1
restorecon -Rv /mnt/
sleep 1
uuid_md5p1=$(blkid -o value -s UUID /dev/md5p1)
uuid_md5p2=$(blkid -o value -s UUID /dev/md5p2)
uuid_md5p3=$(blkid -o value -s UUID /dev/md5p3)
uuid_md5p4=$(blkid -o value -s UUID /dev/md5p4)
uuid_md5p5=$(blkid -o value -s UUID /dev/md5p5)
sleep 1
echo "UUID=$uuid_md5p1 /mnt/md5p1  ext4 defaults 0 0" >> /etc/fstab
echo "UUID=$uuid_md5p2 /mnt/md5p2  ext4 defaults 0 0" >> /etc/fstab
echo "UUID=$uuid_md5p3 /mnt/md5p3  ext4 defaults 0 0" >> /etc/fstab
echo "UUID=$uuid_md5p4 /mnt/md5p4  ext4 defaults 0 0" >> /etc/fstab
echo "UUID=$uuid_md5p5 /mnt/md5p5  ext4 defaults 0 0" >> /etc/fstab