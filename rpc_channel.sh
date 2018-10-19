#!/bin/bash
declare -A RPCCallbackCluster=()
declare PROC_CLIENT_CHANNEL_CREATED=false
declare RPC_CLIENT_CHANNEL_PORT=8877
function InitRPCChannelNoSafe {
	local response_port=$(GetRangeRandom 10000 65000)
	local response_thread_num=0
	if [ $# -eq 0 ];then
		response_thread_num=${RPC_DEFAULT_CLIENT_THREAD}
	else
		response_thread_num=${2}
	fi
	RPOC_CLIENT_CHANNEL_CREATED=false
    RPC_CLIENT_CHANNEL_PORT=${response_port}
	CreateProcessUnit ${response_port} ${response_thread_num} ${RPC_PROCESS_CLIENT_MODE}
	if [ ${RPC_FAIL} -eq $? ];then
		return ${RPC_FAIL}
	fi
	sleep 1s
	return ${RPC_SUCCESS}
}

