#!/bin/bash
source ${rpc_lib_base_path}/rpc_client_stream.sh
source ${rpc_lib_base_path}/rpc_common.sh
source ${rpc_lib_base_path}/rpc_channel.sh
declare CLIENT_REF_COUNT=0
function InitRPCClientEnv {
	if [ ${PROC_CLIENT_CHANNEL_CREATED} == false ];then
	    InitRPCChannelNoSafe
		if [ ${RPC_FAIL} -eq $? ];then
			return ${RPC_FAIL}
		fi
	fi
	PROC_CLIENT_CHANNEL_CREATED=true
	return ${RPC_SUCCESS}
}
function CreateRPCClientStubNoSafe {
	let "CLIENT_REF_COUNT++"
	return ${RPC_SUCCESS}
}
function DestroyRPCClientStubNoSafe {
	let "CLIENT_REF_COUNT--"
	if [ ${CLIENT_REF_COUNT} -eq 0 ];then
		StopClientResponseServer ${RPC_CLIENT_CHANNEL_PORT} ${RPC_DEFAULT_CLIENT_THREAD}
	fi
	return ${RPC_SUCCESS} 
}
function StopClientResponseServer {
	local listen_port=${1}
	local processor_num=${2}
	local stop_request=$(proto_stop_request_make)
	stop_request=$(proto_stop_request_put_role ${stop_request} ${RPC_CONTROL_ROLE_SERVER})
	stop_request=$(proto_stop_request_put_token ${stop_request} "unknow")
	stop_request=$(proto_stop_request_put_round_idx ${stop_request} 1)
	stop_request=$(proto_stop_request_put_max_round_idx ${stop_request} ${processor_num})
	stop_request=$(proto_stop_request_put_bind_port ${stop_request} ${listen_port})
	
	local sequence_no=$(GetSeqNo)
	local request_msg=$(CSMakeRPCRequest ${RPC_CONTROL_REQUEST} ${RPC_CONTROL_STOP_COMMAND} \
		"Nop" ${sequence_no} ${listen_port} ${stop_request})
	
	local local_ip=$(IONetGetLocalIPDec)
	SendByteStream ${local_ip} ${listen_port} ${sequence_no} ${request_msg}
	#wait
}
function RPCClientAsyncCall {
	local method_path=${1}
	local request_context=${2}
	local callback_method=${3}
	local seq_no=$(GetSeqNo)
	#TO-DO add method_path validation
	local remote_addr=$(echo "${method_path}"|cut -d":" -f1)
	if [ -z "${remote_addr}" ];then
		RPCLog "[ERROR] bad remote method path ${method_path}"
		return ${RPC_FAIL}
	fi
    local remote_port=$(echo "${method_path}"|cut -d":" -f2|\
		cut -d"/" -f1)
	if [ -z "${remote_port}" ];then
		RPCLog "[ERROR] bad remote method path ${method_path}"
		return ${RPC_FAIL}
	fi
	local remote_method=${method_path##*/}
	if [ -z "${remote_method}" ];then
		RPCLog "[ERROR] bad remote method path ${method_path}"
		return ${RPC_FAIL}
	fi
	
    local request_message=$(CSMakeRPCRequest ${RPC_SERVICE_REQUEST} \
		${remote_method} ${callback_method} ${seq_no} ${RPC_CLIENT_CHANNEL_PORT} \
		${request_context})
	if [ -z "${request_message}" ];then
		return ${RPC_FAIL}
	fi

	SendByteStream ${remote_addr} ${remote_port} ${seq_no} \
		${request_message}
	if [ ${RPC_SUCCESS} -ne $? ];then
		return ${RPC_FAIL}
	fi
	return ${RPC_SUCCESS}
}
