echo "Data Syncron Fashion "
rsync -avzuh -e "ssh -p1337" /home/server/Videos  fashion@121302207384.ip-dynamic.com:/home/fashion/remote  --progress 

