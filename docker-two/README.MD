docker build -t xubiao05/cfs-server:v3.3.2 -f Dockerfile-cfs-server .

docker build -t xubiao05/cfs-client:v3.3.2 -f Dockerfile-cfs-client .

docker build -t xubiao05/blobstore:v3.3.2 -f docker-two/Dockerfile-cfs-blobstore .