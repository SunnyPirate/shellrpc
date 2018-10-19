#!/bin/bash
source ${rpc_lib_base_path}/rpc_def.sh
source ${rpc_lib_base_path}/rpc_control.sh
source ${rpc_lib_base_path}/rpc_byte_stream.sh
source ${rpc_lib_base_path}/proto_parser/proto_stop_request.sh
function CreateRPCServer {
	local listen_port=${1}
	local processor_num=${2}
	CreateProcessUnit ${listen_port} ${processor_num} ${RPC_PROCESS_SERVER_MODE}  
	if [ ${RPC_FAIL} -eq $? ];then
		return ${RPC_FAIL}
	fi
}
function StartRPCServer {
	RPCLog "[INFO] Start RPC Server"
}
function RunRPCServer {
	wait
}
function StopRPCServer {
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
	wait
}
