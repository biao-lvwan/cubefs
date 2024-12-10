docker build -t xubiao05/cfs-server:v3.3.2 -f Dockerfile-cfs-server .

docker build -t xubiao05/cfs-client:v3.3.2 -f Dockerfile-cfs-client .

docker build -t xubiao05/blobstore:v3.3.2 -f docker-two/Dockerfile-cfs-blobstore .

docker save -o blobstore.tar xubiao05/blobstore:v3.3.2

docker build -t xubiao05/blobstore:v3.3.2-cli -f docker-two/Dockerfile-cfs-blobstore-cli .

./blobstore-cli -c cli.conf

# 上传一个文件，成功后会返回存储位置 (-d 参数后跟实际数据)
# 创建卷
# cfs-cli 读配置文件 ~/.cfs-cli.json. 示例 cfs-cli.json 内容如下
cd bin
./cfs-cli  -c cfs-cli.json
./cfs-cli volume create ltptest ltptest

./cfs-client -c client.conf


./cfs-cli volume mount test-cold1 /mnt/cubefs

./cfs-cli volume info test-cold1

#
./cfs-client -c client.conf

# 创建纠删码的卷volTypel,纠删卷
http://192.168.8.183:17010/admin/createVol?name=test-cold&capacity=1&owner=cubefs&volType=1
# 获取卷列表
http://192.168.8.183:17010/vol/list
# 创建用户
http://192.168.8.183:17010/user/info?user=cubefs

# 查询卷信息
http://192.168.8.206:9998/stat
http://192.168.8.183:17010/admin/getVol?name=test-cold
# access put -v -d "test -data-"
#"code_mode":11 编码模式，对应EC3P3
{"cluster_id":1,"code_mode":10,"size":11,"blob_size":8388608,"crc":2359314771,"blobs":[{"min_bid":1844899,"vid":158458,"count":1}]}

# 下载文件
$> access get -v -l '{"cluster_id":1,"code_mode":10,"size":11,"blob_size":8388608,"crc":2359314771,"blobs":[{"min_bid":1844899,"vid":158458,"count":1}]}'

# 删除文件
$> access del -v -l '{"cluster_id":1,"code_mode":10,"size":11,"blob_size":8388608,"crc":2359314771,"blobs":[{"min_bid":1844899,"vid":158458,"count":1}]}'


# 使用EC码的时候，需要和磁盘进行挂钩
比如和EC3p3进行对比