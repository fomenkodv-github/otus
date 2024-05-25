5.0. Дисковая подсисьема. Работа с mdadm.

 Стенд на основе vagrant box Centos 7. Дополнительные диски (/dev/sd[b-e]).

 Исходное состояние дисквовй подсистемы:

 [vagrant@otuslinux ~]$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   40G  0 disk
└─sda1   8:1    0   40G  0 part /
sdb      8:16   0  250M  0 disk
sdc      8:32   0  250M  0 disk
sdd      8:48   0  250M  0 disk
sde      8:64   0  250M  0 disk

Подготовка к созданию массива:

[vagrant@otuslinux ~]$ sudo mdadm --zero-superblock /dev/sd[b-e]

Создание массива:

[vagrant@otuslinux ~]$ sudo mdadm --create /dev/md5 --level=raid5 --raid-devices=4 /dev/sd[b-e]

Проверка массива:

[vagrant@otuslinux ~]$ sudo mdadm --detail /dev/md5
/dev/md5:
           Version : 1.2
     Creation Time : Sat May 25 07:59:33 2024
        Raid Level : raid5
        Array Size : 761856 (744.00 MiB 780.14 MB)
     Used Dev Size : 253952 (248.00 MiB 260.05 MB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Sat May 25 07:59:36 2024
             State : clean
    Active Devices : 4
   Working Devices : 4
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:5  (local to host otuslinux)
              UUID : 09aaa89a:877b5257:c0657116:f41985dd
            Events : 18

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       4       8       64        3      active sync   /dev/sde


Сохрание конфигурации массива:

[vagrant@otuslinux ~]$ mdadm --detail --scan > /etc/mdadm.conf

Создание файловой системы:

[vagrant@otuslinux ~]$ sudo mk2fs.ext4 /dev/md5

Монтирование массива:

[vagrant@otuslinux ~]$ sudo mount /dev/md5 /mnt/md5/

[vagrant@otuslinux ~]$ sudo blkid | grep md5
/dev/md5: UUID="e92d93a1-5755-4baa-add2-9a5b56c91c92" TYPE="ext4"

[root@otuslinux vagrant]# echo "UUID=e92d93a1-5755-4baa-add2-9a5b56c91c92  /mnt/md5 ext4    defaults 0 0" >> /etc/fstab

[root@otuslinux md5]# mount | grep md5
/dev/md5 on /mnt/md5 type ext4 (rw,relatime,seclabel,stripe=384,data=ordered)

[root@otuslinux md5]# df -h | grep md5
/dev/md5        717M  1.5M  663M   1% /mnt/md5


Удаление (сбой) одного диска из массива:

[root@otuslinux md5]# mdadm --manage /dev/md5 --fail /dev/sdb
mdadm: set /dev/sdb faulty in /dev/md5

[root@otuslinux md5]# mdadm -D /dev/md5
/dev/md5:
           Version : 1.2
     Creation Time : Sat May 25 07:59:33 2024
        Raid Level : raid5
        Array Size : 761856 (744.00 MiB 780.14 MB)
     Used Dev Size : 253952 (248.00 MiB 260.05 MB)
      Raid Devices : 4
     Total Devices : 4
       Persistence : Superblock is persistent

       Update Time : Sat May 25 08:32:15 2024
             State : clean, degraded
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 1
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:5  (local to host otuslinux)
              UUID : 09aaa89a:877b5257:c0657116:f41985dd
            Events : 22

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       4       8       64        3      active sync   /dev/sde

       0       8       16        -      faulty   /dev/sdb


[root@otuslinux md5]# mdadm --manage /dev/md5 --remove /dev/sdb
mdadm: hot removed /dev/sdb from /dev/md5

Добавление дополнительного диска в vagrant:

                    :sata5 => {
                        :dfile => 'sata5.vdi',
                        :size => 250, # Megabytes
                        :port => 5
                    },
                    :sata6 => {
                        :dfile => 'sata6.vdi',
                        :size => 250, # Megabytes
                        :port => 6
                    }


Дополнительные диски в системе (sdf + sdg):

[root@otuslinux md5]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
sda      8:0    0   40G  0 disk
└─sda1   8:1    0   40G  0 part  /
sdb      8:16   0  250M  0 disk
sdc      8:32   0  250M  0 disk
└─md5    9:5    0  744M  0 raid5 /mnt/md5
sdd      8:48   0  250M  0 disk
└─md5    9:5    0  744M  0 raid5 /mnt/md5
sde      8:64   0  250M  0 disk
└─md5    9:5    0  744M  0 raid5 /mnt/md5
sdf      8:80   0  250M  0 disk
sdg      8:96   0  250M  0 disk


Добавление новых дисков в массив:

[root@otuslinux md5]# mdadm --zero-superblock /dev/sd[f-g]

[root@otuslinux md5]# mdadm --examine /dev/sd[f-g]
mdadm: No md superblock detected on /dev/sdf.
mdadm: No md superblock detected on /dev/sdg.

[root@otuslinux md5]# mdadm --manage /dev/md5 --add /dev/sd[f-g]
mdadm: added /dev/sdf
mdadm: added /dev/sdg

Диски добавлены (4 active + 1 spare):

[root@otuslinux md5]# mdadm -D /dev/md5
/dev/md5:
           Version : 1.2
     Creation Time : Sat May 25 07:59:33 2024
        Raid Level : raid5
        Array Size : 761856 (744.00 MiB 780.14 MB)
     Used Dev Size : 253952 (248.00 MiB 260.05 MB)
      Raid Devices : 4
     Total Devices : 5
       Persistence : Superblock is persistent

       Update Time : Sat May 25 08:40:36 2024
             State : clean
    Active Devices : 4
   Working Devices : 5
    Failed Devices : 0
     Spare Devices : 1

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:5  (local to host otuslinux)
              UUID : 09aaa89a:877b5257:c0657116:f41985dd
            Events : 43

    Number   Major   Minor   RaidDevice State
       6       8       96        0      active sync   /dev/sdg
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       4       8       64        3      active sync   /dev/sde

       5       8       80        -      spare   /dev/sdf


Создание GPT:

[root@otuslinux md5]# gdisk /dev/md5
GPT fdisk (gdisk) version 0.8.10

Partition table scan:
  MBR: not present
  BSD: not present
  APM: not present
  GPT: not present

Creating new GPT entries.

Command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): Y
OK; writing new GUID partition table (GPT) to /dev/md5.
Warning: The kernel is still using the old partition table.
The new table will be used at the next reboot.
The operation has completed successfully.


[root@otuslinux vagrant]# mkfs.ext4 /dev/md5

[root@otuslinux vagrant]# blkid | grep md5
/dev/md5: UUID="f3300368-ad2f-4770-8a14-f16be34b9edb" TYPE="ext4" PARTUUID="c9b6f7e7-f024-485c-9d23-cfb6e4575682"

[root@otuslinux vagrant]# mount /dev/md5  /mnt/md5/