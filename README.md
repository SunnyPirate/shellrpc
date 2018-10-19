# ShellRPC
## 概述
项目用BASH实现的一个简易的RPC框架，你可以用Shell来实现跨机器的RPC的调用，也就是说你可以用Shell来写网络服务，当然BASH可能不是你最好的选择，但是这个小东西却提供了一个快速和简单的实现，让你用Shell也可以实现复杂的远程服务调用。
## 整体介绍
这个小东西整体上实现了如下几个核心功能：
* proto解析代码自动生成，序列化与反序列化
* service服务端的多进程处理模型
* client端的对服务的异步调用

### proto的解析
你可以像其他所有的RPC框架一样定义你自己的proto格式，我们以一个AddService为例，服务的功能是将客户端传递过来的两个数做加法运算，我们可以这样定义add_request.proto
```c++
param1
param2
```
接下来我们定义add_response.proto,也就是服务端返回给客户端的proto描述
```c++
sum：1
```
这样我们定义好我们的request和response的数据结构后，我们调用rpc_proto_cg.sh,命令如下：
```c++
sh rpc_proto_cg.sh ./add_request.proto
sh rpc_proto_cg.sh ./add_response.proto
```
这样我们将得到两个sh文件分别是proto_add_request.sh和proto_add_response.sh,这两个文件
包含对其中字段的读取.写入以及序列化和反序列化的函数，这些函数不建议修改。

### 编写service
这里我们以AddService为例，首先我们先定义服务端处理的函数，如下所示:
```c++
function AddService {
  local request=${1}
  local param1=$(proto_add_request_get_param1 ${request})
  local param2=$(proto_add_request_get_param2 ${request})
  local sum=0
  let "sum=param1+param2"
  local response=$(proto_add_response_make)
  response=$(proto_add_response_put_sum ${response} ${sum})
  echo ${response}
}
```
函数比较好理解，首先我们调用自动生成的函数来获取client通过网络发送过来的传入的参数param1和param2,这里面底层涉及到解码和反序列化的过程，使用上可以忽略。然后我们对param1和param2进行加法计算，得到的结果我们通过构造一个response并把他放入之前我们定义的sum字段，最后把这个response输出，剩下的将交给框架处理，通过网络，最后的response会传递给client端。
接下来我们编写客户端的回调函数AddServiceCallback，代码如下：
```c++
function AddServiceCallback {
  local response=${1}
  local sum=$(proto_add_response_get_sum ${response})
  RPCLog "[INFO]AddService return ${sum}"
}
```
这里的回调函数在客户端运行，因为目前只实现了异步调用，所以需要写回调函数来处理返回结果。
当然，同步是在异步的基础上实现的，未来不久将提供。
### 实现调用
对于客户端你需要先初始化client的环境，然后创建client的stub，最后通过对应的异步函数发起rpc调用，大概的代码如下：
```c++
function MainProcess {
  local ip=$(IONetGetLocalIPDec)
  local rpc_server_port=8877
  InitRPCClientEnv
  if [ ${RPC_FAIL} -eq $? ];then
    RPCLog "[Error] init RPC client env fail"
    return ${RPC_FAIL}
  fi
  CreateRPCClientStubNoSafe
  local add_request=$(proto_add_request_make)
  add_request=$(proto_add_request_put_param1 ${add_request} "1")
  add_request=$(proto_add_request_put_param2 ${add_request} "2")

  RPCClientAsyncCall "${ip}:${rpc_server_port}/AddService" ${add_request} AddServiceCallback
  if [ ${RPC_SUCCESS} -ne $? ];then
     echo "Send Request fail"
  fi
}
```
这里需要注意的对服务的调用格式是***ip:port/service_name***

## 几个需要关注的地方
### 主要的依赖
* netcat工具，大多数Linux发行版里面都会有
* lsof，可能你需要安装
* 没啦，确实没了

### 服务端的细节
* 你可以配置后台处理任务的进程数，已经提供shell的mutexlock的实现。
* 启动的时候最好判断返回值，防止端口被占用。
* 停止服务请调用StopServer，目前已经实现了优雅退出。

### 客户端的细节
* 客户端需要先调用初始化环境函数，主要是初始化后台的接收返回消息的服务
* 客户端目前的调用均为异步的方式。
* 客户端目前也支持优雅的退出

### 性能
Shell写的你懂的，并不是很高，不过既然是shell写的性能可能不是主要的关键点。

## demo
目前系统中已经实现了EchoService的Demo以及AddService的Demo,具体可以参考demo文件夹下的
示例
## 后续计划
* 支持同步的Service调用
* 支持传输数据的压缩，目前的编码方式会导致数据一定的膨胀
* 支持HTTP服务
