git:
  pkg:
    - installed
    - order: 1

maven:
  pkg:
   - installed 
   - order: 2

debconf-utils:
  pkg:
    - installed
    - order: 4

add-oracle-ppa:
  cmd.run:
    - name: 'sudo add-apt-repository ppa:webupd8team/java -y'
    - order: 5 

update-repo:
  cmd.run:
    - name: 'sudo apt-get update'
    - order: 6 

update-debconf:
  cmd.run:
    - name: 'echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections'
    - order: 6

update-debconf2:
  cmd.run:
    - name: ' echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections'
    - order: 7

install-oracle-java7:
  cmd.run:
    - name: 'sudo apt-get -y install oracle-java7-installer'
    - order: 8  

lbaas-api-git:
   require:
     - pkg: git
   git.latest:
    - order: 9 
    - cwd: /home/ubuntu
    - name: https://github.com/LBaaS/lbaas-api.git
    - target: /home/ubuntu/lbaas-api
    - force: True

add-gearman-m2-repo:
  cmd.run:
    - name: 'mvn install:install-file -DgroupId=gearman -DartifactId=java-gearman-service -Dversion=0.6.5 -Dpackaging=jar -Dfile=gearman/java-gearman-service-0.6.5.jar'
    - cwd: /home/ubuntu/lbaas-api
    - order: 10  

build-lbaas-api:
  cmd.run:
    - name: 'mvn clean install'
    - cwd: /home/ubuntu/lbaas-api
    - order: 11 

build-lbaas-api2:
  cmd.run:
    - name: 'mvn assembly:assembly'
    - cwd: /home/ubuntu/lbaas-api
    - order: 12  

# make logs dir
/home/ubuntu/lbaas-api/logs:
  file.directory:
    - group: users
    - mode: 755
    - makedirs: True
    - order: 17

start-api-server:
  cmd.run:
   - name: './lbaas.sh start'
   - cwd: /home/ubuntu/lbaas-api
   - order: last 

# TODO: check the server is running
# parse the log maybe?
