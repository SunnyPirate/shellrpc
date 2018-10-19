#!/bin/bash
source ../../rpclib.sh
source ../../proto_parser/proto_echo_request.sh
trap "ExitProcess" 2
module_running=0
function ExitProcess {
	DestroyRPCClientStubNoSafe ${client_id}
	wait 
	module_running=1
}
function MainProcess {
	local ip=$(IONetGetLocalIPDec)
    local rpc_server_port=8877
	InitRPCClientEnv
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[Error] init RPC client env fail"
		return ${RPC_FAIL}
	fi
	CreateRPCClientStubNoSafe
	local echo_request=$(proto_echo_request_make)
	echo_request=$(proto_echo_request_put_name ${echo_request} "sunwei")
	RPCClientAsyncCall "${ip}:${rpc_server_port}/EchoService" ${echo_request} EchoServiceCallback
	if [ ${RPC_SUCCESS} -ne $? ];then
		echo "Send Request fail"
	fi
	while [ 0 -eq ${module_running} ]
	do
		sleep 1s
	done
	
} 
MainProcess
