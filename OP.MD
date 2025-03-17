# 编译
docker build -t xubiao05/cubefs:1.0 .

docker-compose -f docker-compose.yaml up -d 

# 编译
make build

# 模块断点
# 1,资源管理节点(masternodde)
由多个 Master 节点组成，负责异步处理不同类型的任务，
如管理数据分片与元数据分片（包括创建、删除、更新以及一致性检查等），检查数据节点或者元数据节点的健康状态，维护管理卷信息等
Master 节点可以有多个，节点之间通过 Raft 算法保证元数据的一致性，并且持久化到 RocksDB 中。

# 2,元数据子系统(metanode)
由多个 Meta Node 节点组成，多个元数据分片（Meta Partition）和 Raft 实例
（基于 Multi-Raft 复制协议）组成，每个元数据分片表示一个 Inode 范围元数据，
其中包含两棵内存 B-Tree 树：inode BTree 与 dentry BTree。
元数据实例最少需要 3 个，支持水平扩容。

# 数据子系统(datanode,blobstore)
分为副本子系统和纠删码子系统，两种子系统可同时存在，也都可单独存在：
副本子系统由 DataNode 组成，每个节点管理一组数据分片，多个节点的数据分片构成一个副本组；
纠删码子系统（Blobstore）主要由 BlobNode 模块组成，每个节点管理一组数据块，多个节点的数据块构成一个纠删码条带。
数据节点支持水平扩容。

# 对象子系统(objectnode)
由对象节点（ObjectNode）组成，提供了兼容标准 S3 语义的访问协议，
可以通过 Amazon S3 SDK 或者是 s3cmd 等工具访问存储资源。

# 卷
逻辑上的概念，由多个元数据和数据分片组成，从客户端的角度看，卷可以被看作是可被容器访问的文件系统实例。从对象存储的角度来看，一个卷对应着一个 bucket。一个卷可以在多个容器中挂载，使得文件可以被不同客户端同时访问。

Master：资源管理节点，负责维护整个集群的元信息，部署为 StatefulSet 资源。
DataNode：数据存储节点，需要挂载大量磁盘负责文件数据的实际存储，部署为 DaemonSet 资源。
MetaNode：元数据节点，负责存储所有的文件元信息，部署为 DaemonSet 资源。
# 使用daemonset模式
# 确保每个节点运行一个副本：DaemonSet 会确保集群中每个节点（或某些特定节点）上运行一个 Pod 副本。对于 CubeFS 的 MetaNode 来说，这种部署方式可以确保元数据服务在集群中均匀分布，提高服务的可用性和性能。
# 高可用性和容灾能力：通过在多个节点上部署 MetaNode，即使某个节点出现故障，其他节点上的 MetaNode 仍可以继续提供服务，从而增强了系统的容灾能力。
# 直接使用宿主机网络：CubeFS 的 MetaNode 部署为 DaemonSet 资源时，可以直接使用宿主机网络，避免了额外的网络开销，提高了性能。
# 方便的扩展和管理：使用 DaemonSet 部署使得在集群中添加或移除节点时，MetaNode 的扩展和缩容变得非常方便。只需给新节点打上相应的标签，DaemonSet 就会自动在该节点上创建或删除 Pod。
# 与节点生命周期绑定：DaemonSet 中的 Pod 生命周期与节点绑定。当节点加入或离开集群时，DaemonSet 会自动管理 Pod 的创建和删除，这与 CubeFS 对元数据节点的管理需求相契合
ObjectNode：负责提供转换 S3 协议提供对象存储的能力，无状态服务，部署为 Deployment 资源。
