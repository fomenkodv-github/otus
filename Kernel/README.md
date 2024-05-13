version 1.1
Занятие 1. Vagrant-стенд для обновления ядра и создания образа системы

Для задания на платформе Windows 11 использована nested виртуализация:

    - vagrantfile для хост системы Windows описывающий создание VM Ubuntu Desktop 22.04
    - импортирован box из репозитория: virusstyle/ubuntu-22.04-desktop-amd64
    - для включения nested виртуализации средствами vagrant был применен код: 

    jd.vm.provider "virtualbox" do |vb|
      vb.memory = 24000
      vb.cpus = 6
      vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']  # Включение nested виртуализации


    - VM развернута и настроена
    - В VM импортирован box: generic/centos8
    - Запущена внутренняя nested VM centos8


Обновлено ядро linux Centos из репозитория  
