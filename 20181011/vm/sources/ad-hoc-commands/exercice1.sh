echo "the content of the file to copy" > file.txt

#Copy a file on each remote node to /tmp using copy module
ansible all  -i /home/montasar/inventory/hosts -m copy -a "src=file.txt dest=/tmp/file.txt"

#Retrieve the checksum and md5 of the copied file using stat module
ansible all  -i /home/montasar/inventory/hosts -m stat -a "path=/tmp/file.txt"

#Remove the copied file from each remote node using file module
ansible all  -i /home/montasar/inventory/hosts -m file -a "path=/tmp/file.txt state=absent"

#Create a file /tmp/helloworld.txt on each remote node with content « Hello World »
ansible all  -i /home/montasar/inventory/hosts -m copy -a "dest=/tmp/helloworld.txt content='Hello World'"

#Replace « World » with ansible user name
ansible all  -i /home/montasar/inventory/hosts -m replace -a "dest=/tmp/helloworld.txt replace='Hello $(whoami)' regexp='Hello World'"

#Download prebuild elastic search v 2.4.1 to /tmp/elasticsearch-2.4.1.tar.gz
ansible all  -i /home/montasar/inventory/hosts -m get_url -a "dest=/tmp/elasticsearch-2.4.1.tar.gz url='https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.4.1/elasticsearch-2.4.1.tar.gz'"

#Unpack elastic search to /tmp
ansible all  -i /home/montasar/inventory/hosts -m unarchive -a "copy=no src=/tmp/elasticsearch-2.4.1.tar.gz dest=/tmp"


#Retrieve apache preferred mirror for each node
???????


#Install openjdk 8 on redhat and Debian VMs using respectively yum and apt (http://openjdk.java.net/install/)
ansible ansible-redhat.vm  -i /home/montasar/inventory/hosts -m yum -a "name=java-1.8.0-openjdk state=latest update_cache=yes" -b
ansible ansible-debian.vm  -i /home/montasar/inventory/hosts -m apt -a "name=openjdk-8-jre state=latest update_cache=yes" -b


#Create user smartlake on each managed node
# * an ssh 2048 rsa key should be generated on redhat VM only
# * the public key should be fetched and authorized for debian VM (using lookup file)
# * Its UID should be 2000
# * Its principal group should be smartlake with GID 2000
ansible all  -i /home/montasar/inventory/hosts -m group -a "name=smartlake gid=2000 state=present" -b
ansible ansible-redhat.vm  -i /home/montasar/inventory/hosts -m user -a "name=smartlake uid=2000 group=smartlake generate_ssh_key=yes ssh_key_type=rsa ssh_key_bits=2048" -b
ansible ansible-redhat.vm  -i /home/montasar/inventory/hosts -m fetch -a "src=/home/smartlake/.ssh/id_rsa.pub dest=/tmp/ssh_key/id_rsa.pub flat=yes" -b
ansible ansible-debian.vm  -i /home/montasar/inventory/hosts -m user -a "name=smartlake uid=2000 group=smartlake" -b
ansible ansible-debian.vm  -i /home/montasar/inventory/hosts -m copy -a "src=/tmp/ssh_key/id_rsa.pub dest=/tmp/id_rsa_redhat_vm.pub" -b
ansible ansible-debian.vm  -i /home/montasar/inventory/hosts -m file -a "path=/home/smartlake/.ssh state=directory" -b
ansible ansible-debian.vm  -i /home/montasar/inventory/hosts -m file -a "path=/home/smartlake/.ssh/authorized_keys" -b
ansible ansible-debian.vm  -i /home/montasar/inventory/hosts -m shell -a "cat /tmp/id_rsa_redhat_vm.pub >> /home/smartlake/.ssh/authorized_keys" -b

