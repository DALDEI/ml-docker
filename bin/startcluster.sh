
 docker network create --subnet 203.0.113.0/24 --gateway 203.0.113.254 iptastic

 for h in {4,5,6} ; do 
    docker run --rm --name ml-runner-$h --net iptastic --ip 204.0.113.$h --hostname ml-runner-$h --add-host ml-runner-05:204.0.113.5 --add-host ml-runner-04:204.0.113.4 -it -P ml-docker/marklogic-runner
 docker run --rm --name ml-runner-06 --net iptastic --ip 204.0.113.6 --hostname ml-runner-06 --add-host ml-runner-05:204.0.113.5 --add-host ml-runner-04:204.0.113.4 -it -P ml-docker/marklogic-runner
 docker run --rm --name ml-runner-06 --net iptastic --ip 204.0.113.6 --hostname ml-runner-06 --add-host ml-runner-05:204.0.113.5 --add-host ml-runner-04:204.0.113.4 -it -P ml-docker/marklogic-runner

