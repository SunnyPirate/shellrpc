#!/bin/bash
source ${rpc_lib_base_path}/rpc_def.sh
source ${rpc_lib_base_path}/proto_parser/proto_rpc_meta.sh
source ${rpc_lib_base_path}/proto_parser/proto_rpc_message.sh
source ${rpc_lib_base_path}/proto_parser/proto_stop_request.sh
source ${rpc_lib_base_path}/proto_parser/proto_stop_response.sh


function SysGetPIDFromPort {
	local port=${1}
	local pid=$(lsof -i:${port}|grep "(LISTEN)$"|awk '{print $2}')
	if [ -n "${pid}" ];then
		echo ${pid}
	fi
	echo ""
}
function ExecuteControlCommand {
	local meta=${1}
	local data=${2}
	local method=$(proto_rpc_meta_get_method ${meta})

	case ${method} in
	${RPC_CONTROL_STOP_COMMAND})
    ExecuteStopServer ${meta} ${data}
	return ${RPC_PROCESSOR_FLOW_STOP}
	;;
	
	esac
}

function StopListener {
	local bind_port=${1}
	local pid=$(SysGetPIDFromPort ${bind_port})
	if [ -z  "${pid}" ];then
	    return ${RPC_SUCCESS}
	fi
	local max_try_time=10
	local try_count=0
	while [ ${try_count} -lt ${max_try_time} ]
	do 
		pid=$(SysGetPIDFromPort ${bind_port})
	    if [ -z  "${pid}" ];then
	        break
	    else 
	        kill -9 ${pid}
			let "try_count++"
		    sleep 1s	
			continue
		fi
	done
	if [ ${try_count} -eq ${max_try_time} ];then
		RPCLog "[ERROR] stop listener bind on port ${bind_port} fail"
		return ${RPC_FAIL}
	fi
	RPCLog "[INFO] stop listener bind on port ${bind_port} success"
	return ${RPC_SUCCESS}
}
function ExecuteStopServer {
	local meta=${1}
	local data=${2}
	
	local round_idx=$(proto_stop_request_get_round_idx ${data}) 
	local max_round_idx=$(proto_stop_request_get_max_round_idx ${data})
	local bind_port=$(proto_stop_request_get_bind_port ${data})
	
	local sequence_no=$(proto_rpc_meta_get_sequence_no ${meta})
	local callback_method=$(proto_rpc_meta_get_callback_method ${meta})
	local callback_port=$(proto_rpc_meta_get_callback_port ${meta})
	callback_port=$(HexPortToDec ${callback_port})
	

	if [ ${round_idx} -eq ${max_round_idx} ];then
		local role=$(proto_stop_request_get_role ${data})
	    StopListener ${bind_port}
		if [ ${role} == "${RPC_CONTROL_ROLE_SERVER}" ];then
		     return 	
		fi
	    local response=$(proto_stop_response_make)
		response=$(proto_stop_response_put_result ${response} "Stop Server done")
	    response_msg=$(SSMakeRPCResponse ${RPC_SERVICE_RESPONS} \
			${sequence_no} ${callback_method} ${response})
		local source_ip=$(proto_rpc_meta_get_source_ip ${meta})
		SendByteStream ${source_ip} ${callback_port} ${sequence_no} ${response_msg}
	else
	    let "round_idx++"	
	    data=$(proto_stop_request_put_round_idx ${data} ${round_idx})	
	    local local_ip=$(IONetGetLocalIPDec)
		local request_msg=$(CSMakeRPCRequest ${RPC_CONTROL_REQUEST} ${RPC_CONTROL_STOP_COMMAND} ${callback_method} \
			${sequence_no} ${callback_port} ${data})
		SendByteStream ${local_ip} ${bind_port} ${sequence_no} ${request_msg}
	fi
}
