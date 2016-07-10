/etc/init.d/MarkLogic start 
sleep 5
while /etc/init.d/MarkLogic status ; do 
  sleep 10
done
