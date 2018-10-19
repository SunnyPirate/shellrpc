#!/bin/bash
source ../../rpclib.sh
source ../../proto_parser/proto_add_request.sh
source ../../proto_parser/proto_add_response.sh
source ./add_service.sh

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
	local add_request=$(proto_add_request_make)
	add_request=$(proto_add_request_put_param1 ${add_request} "1")
	add_request=$(proto_add_request_put_param2 ${add_request} "2")

	RPCClientAsyncCall "${ip}:${rpc_server_port}/AddService" ${add_request} AddServiceCallback
	if [ ${RPC_SUCCESS} -ne $? ];then
		echo "Send Request fail"
	fi
	while [ 0 -eq ${module_running} ]
	do
		sleep 1s
	done
	
} 
MainProcess
