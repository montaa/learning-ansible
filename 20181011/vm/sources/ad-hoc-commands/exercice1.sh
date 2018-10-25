echo "the content of the file to copy" > file.txt
ansible all  -i /home/montasar/inventory/hosts -m copy -a "src=file.txt dest=/tmp/file.txt"
ansible all  -i /home/montasar/inventory/hosts -m stat -a "path=/tmp/file.txt"
ansible all  -i /home/montasar/inventory/hosts -m file -a "path=/tmp/file.txt state=absent"
ansible all  -i /home/montasar/inventory/hosts -m copy -a "dest=/tmp/helloworld.txt content='Hello World'"
ansible all  -i /home/montasar/inventory/hosts -m replace -a "dest=/tmp/helloworld.txt replace='Hello $(whoami)' regexp='Hello World'"
ansible all  -i /home/montasar/inventory/hosts -m get_url -a "dest=/tmp/elasticsearch-2.4.1.tar.gz url='https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.4.1/elasticsearch-2.4.1.tar.gz'"
ansible all  -i /home/montasar/inventory/hosts -m unarchive -a "copy=no src=/tmp/elasticsearch-2.4.1.tar.gz dest=/tmp"
#Install openjdk 8 on redhat and Debian VMs using respectively yum and apt (http://openjdk.java.net/install/)
ansible ansible-redhat.vm  -i /home/montasar/inventory/hosts -m yum -a "name=java-1.8.0-openjdk state=latest update_cache=yes" -b
ansible ansible-debian.vm  -i /home/montasar/inventory/hosts -m apt -a "name=openjdk-8-jre state=latest update_cache=yes" -b


