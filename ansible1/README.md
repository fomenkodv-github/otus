3. Автоматизация администрирования. Ansible-1 

---------------------------------------------

- Подготовка стенда:

	- Развернуты 4 хоста:

		- ansible-srv (Ubuntu, хост с ansible, pubkey auth)
                - ansible-h1  (Ubuntu, password auth)
                - ansible-h2  (Ubuntu, pubkey auth)
                - ansible-h3  (Centos, pubkey auth)

        - Ansible cfg файл был сгенерирован в /home/vagrant/ansible

        - Inventory размещен в: /home/vagrant/ansible

        - Группы хостов в inventory:  

ansible-inventory --graph
@all:
  |--@ungrouped:
  |--@produbt:
  |  |--@prod_h1:
  |  |  |--h1
  |  |--@prod_h2:
  |  |  |--h2
  |--@prodcnt:
  |  |--@prod_h3:
  |  |  |--h3
  |--@prodall:
  |  |--@prod_h1:
  |  |  |--h1
  |  |--@prod_h2:
  |  |  |--h2
  |  |--@prod_h3:
  |  |  |--h3




         - Создана роль deploy_nginx

	 - Структура в ansible:

vagrant@ansible-srv:~/ansible$ tree
.
|-- ansible.cfg
|-- h2.key.pem
|-- h3.key.pem
|-- hosts.txt
|-- pb-prodall-nginx.yml
`-- roles
    `-- deploy_nginx
        |-- README.md
        |-- defaults
        |   `-- main.yml
        |-- files
        |-- handlers
        |   `-- main.yml
        |-- meta
        |   `-- main.yml
        |-- tasks
        |   `-- main.yml
        |-- templates
        |   `-- nginx.conf.j2
        |-- tests
        |   |-- inventory
        |   `-- test.yml
        `-- vars
            `-- main.yml


	- Дополнительно для хоста Centos требуется открыть порт 8080 в firewalld отдельным task с параметром "when: ansible_os_family == "RedHat"" 

	- Для установки nginx разными package managers (apt/yum) был использован ansible.builtin.package с авто определением типа установщика

       

	

