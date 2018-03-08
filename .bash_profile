export MAVEN_OPTS="-Xms1024m -Xmx2048m -XX:PermSize=512m -XX:MaxPermSize=512m"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

title() { echo -ne "\033]0;"$*"\007" }

tab-color() {
    echo -ne "\033]6;1;bg;red;brightness;$1\a"
    echo -ne "\033]6;1;bg;green;brightness;$2\a"
    echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}

tab-reset() {
    echo -ne "\033]6;1;bg;*;default\a"
    title
}

nexus-private() {
    if [ -f ~/.m2/settings-withPrivate.xml ]; then
        mv ~/.m2/settings.xml ~/.m2/settings-withPublic.xml
        mv ~/.m2/settings-withPrivate.xml ~/.m2/settings.xml
        echo -e "${GREEN}Nexus Settings XML file is changed to private${NC}"
    else
        echo -e "${RED}Nexus Settings XML file is already with private IP${NC}"
    fi
}

nexus-public() {
   if [ -f ~/.m2/settings-withPublic.xml ]; then
       mv ~/.m2/settings.xml ~/.m2/settings-withPrivate.xml
       mv ~/.m2/settings-withPublic.xml ~/.m2/settings.xml
       echo -e "${GREEN}Nexus Settings XML file is changed to public${NC}"
   else
       echo -e "${RED}Nexus Settings XML file is already with public IP${NC}"
   fi
}

npm-private() {
    if [ -f ~/.npmrc-withPrivate ]; then
        mv ~/.npmrc ~/.npmrc-withPublic
        mv ~/.npmrc-withPrivate ~/.npmrc
        echo -e "${GREEN}.npmrc file is changed to private${NC}"
    else
        echo -e "${RED}.npmrc is already with private IP${NC}"
    fi
}

npm-public() {
    if [ -f ~/.npmrc-withPublic ]; then
        mv ~/.npmrc ~/.npmrc-withPrivate
        mv ~/.npmrc-withPublic ~/.npmrc
        echo -e "${GREEN}.npmrc file is changed to public${NC}"
    else
        echo -e "${RED}.npmrc file is already with public IP${NC}"
    fi
}

work-private(){
    nexus-private
    npm-private
}

work-public(){
    nexus-public
    npm-public
}

run-orchestra() {
    cd ~/Development/wopr-orchestra
    title Orchestra
    tab-color 224 164 200
    mvn  -Dspring.profiles.active=local spring-boot:run
    tab-reset
}

run-auth() {
    cd ~/Development/wopr-auth
    title Auth
    tab-color 224 234 100
    mvn -Drun.jvmArguments="-Dspring.profiles.active=dev" spring-boot:run
    tab-reset
}

run-discovery() {
    cd ~/Development/wopr-discovery-service 
    title Discovery Service 
    tab-color 170 57 57 
    mvn spring-boot:run 
    tab-reset
}

run-config() {
    cd ~/Development/wopr-config-server 
    title Config Server 
    tab-color 224 164 42 
    mvn spring-boot:run 
    tab-reset
}

run-data-generator() {
    cd ~/Development/wopr-service-data 
    title Data Generator 
    tab-color 5 109 255 
    mvn -DWOPR_CONFIG_SERVER_URL=http://52.208.126.27:8888 -Dspring.profiles.active=dev spring-boot:run 
    tab-reset
}    

run-dynamo() {
    title DynamoDB
    tab-color 209 102 48
    /Users/dev/Development/dynamodb_local_latest/start.sh    
    tab-reset
}

run-cassandra() {
    title Cassandra
    tab-color 293 97 79
    ~/opt/cassandra/bin/cassandra -f 
    tab-reset
}

run-cqlsh() {
    title Cassandra CQLSH 
    tab-color 24 100 100 
    ~/opt/cassandra/bin/cqlsh 
    tab-reset
}

maestro() {
    cd ~/Development/generator-wopr-dashboard/test/maestroV3 
    title --MAESTRO--
    tab-color 255 201 36
    gulp serve
    tab-reset
}

maestro-generate() {
    cd ~/Development/generator-wopr-dashboard 
    rm -rf test/maestroV3 
    title Gulp MeastroV3 
    gulp maestroV3 
    cd test/maestroV3 
    title NPM Install 
    npm install 
    tab-reset 
    maestro
}

update-generator() {
    sudo npm uninstall -g generator-wopr
    sudo npm install -g generator-wopr
}

function to-aws(){
    title Connecting AWS Server $1
    ssh -i ~/Development/pem/wopr-key-pair.pem ec2-user@$1
    tab-reset
}

alias upprofile='vim ~/.bash_profile && source ~/.bash_profile'
alias dmall='cd ~/Development/dmall'
alias dev='cd ~/Development'
alias home='cd ~'
alias cd..='cd ..'
alias sky='cd ~/Development/skynet/sky'
alias kj='killall -9 java'
alias deploysh='dmall && echo "" > mallfront/src/main/webapp/static/js/deps.js && cd mallfront/src/main/webapp/static/ && ./scripts/deploy.sh && cd -'
alias mvt='dmall && mvn clean verify -P test && cd -'
alias mcd='dmall && mvn clean && deploysh'
alias cssp='dmall && mvn -pl mallfront -am clean verify -P test -DskipTests=true && cd -'
alias startrabbit='sudo /usr/local/sbin/rabbitmq-server --detached &'
alias stoprabbit='sudo /usr/local/sbin/rabbitmqctl stop'
alias gel='dmall && git pull'
alias nexusdisable='mv ~/.m2/settings.xml ~/.m2/settings-dontuse.xml'
alias nexusenable='mv ~/.m2/settings-dontuse.xml ~/.m2/settings.xml'

alias ver='dmall && mvn clean verify -T 5 && cd -'
alias verUnit='dmall && mvn clean verify -T 5 -DskipDaoTest=true && cd -'
alias verUnitTest='dmall && mvn clean verify -T 5 -DskipDaoTest=true -P test && cd -'
alias verDao='dmall && mvn clean verify -T 5 -DskipUnitTest=true && cd -'
alias verDaoTest='dmall && mvn clean verify -T 5 -DskipUnitTest=true -P test && cd -'
alias vertest='dmall && mvn clean verify -T 5 -P test && cd -'
alias go-test='ssh developer@172.20.8.22'
alias sshdev='ssh developer@172.18.184.55'
alias fs='curl -u Administrator:123qwe -X POST http://127.0.0.1:8091/pools/default/buckets/SessionBucket/controller/doFlush'
alias fd='curl -u Administrator:123qwe -X POST http://127.0.0.1:8091/pools/default/buckets/DefaultBucket/controller/doFlush'
alias fa='curl -u Administrator:123qwe -X POST http://127.0.0.1:8091/pools/default/buckets/ApplicationBucket/controller/doFlush'
alias f='fs && fd && fa'
alias newjs='dmall && cd mallfront/src/main/webapp/static/ && ./new-design/build/deploy.sh dev && cd -'
alias newsojs='dmall && cd selleroffice/src/main/webapp/resources/ && ./new-design/build/deploy.sh dev && cd -'

alias cache-clear-test='echo "flush_all" | nc 172.20.8.24 11211'

alias java8='export set JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_91.jdk/Contents/Home'
alias java7='export set JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_79.jdk/Contents/Home'
alias java6='export set JAVA_HOME=/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home'

alias run-zookeeper='java8; zkServer start'
alias stop-zookeeper='java8; zkServer stop'

alias run-kafka='java8; kafka-server-start.sh /usr/local/etc/kafka/server.properties'
alias list-kafka-topics='java8; kafka-topics.sh --list --zookeeper localhost:2181'

build-kafka-topic(){ java8 && kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic "$@";}

populate-kafka-topic(){ java8 && kafka-console-producer.sh --broker-list localhost:9092 --topic "$@";}

listen-kafka-topic(){ java8 && kafka-console-consumer.sh --zookeeper localhost:2181 --topic "$@" --from-beginning;}

delete-kafka-topic(){ java8 && kafka-run-class.sh kafka.admin.DeleteTopicCommand --zookeeper localhost:2181 --topic "$@"; }

alias run-cassandra='java8; cassandra'

alias run-harvester='java8; cd ~/Development/harvester; sbt run; cd -'

alias sample-harvester-data='cat ~/Development/skynet/sky/sampleData/events.log| groovy ~/Development/skynet/sky/log-replayer/replay.groovy'

alias sample-harvester-order-data='cat ~/Development/skynet/sky/sampleData/events.log| grep OrderCreate | groovy ~/Development/skynet/sky/log-replayer/replay.groovy'

couchbase-ram(){ cd "/Applications/Couchbase Server.app/Contents/Resources/couchbase-core/bin" && couchbase-cli cluster-init -c 127.0.0.1:8091 -u Administrator -p 123qwe --cluster-init-ramsize=$@; }
