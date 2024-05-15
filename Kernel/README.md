version 1.1
Занятие 1. Vagrant-стенд для обновления ядра и создания образа системы

Для задания на платформе Windows 11 использована nested виртуализация:

    - vagrantfile для хост системы Windows описывающий создание VM Ubuntu Desktop 22.04
    - импортирован box из репозитория: virusstyle/ubuntu-22.04-desktop-amd64
    - Для развертывания хост VM был использован vagrantfile-host
    - для включения nested виртуализации средствами vagrant был применен код: 

    jd.vm.provider "virtualbox" do |vb|
      vb.memory = 24000
      vb.cpus = 6
      vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']  # Включение nested виртуализации


    - VM развернута и настроена 
    - Использован vagrantfile-nested для деплоя nested VM
    - В VM импортирован box: generic/centos8
    - Запущена внутренняя nested VM centos8


Обновлено ядро linux Centos из репозитория:

  - проверена текущая версия ядра:

    [vagrant@centos8-nested ~]$ uname -r
     4.18.0-532.el8.x86_64
  
  - подключен elrepo репозиторий:

  [vagrant@centos8-nested ~]$ sudo yum install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm

  - установлено ядро из свежей и стабильной ветки kernel-ml:

   [vagrant@centos8-nested ~]$ sudo yum --enablerepo elrepo-kernel install kernel-ml -y

  - перезагрузка с новым ядром:

   [vagrant@centos8-nested ~]$ uname -r
    6.8.9-1.el8.elrepo.x86_64