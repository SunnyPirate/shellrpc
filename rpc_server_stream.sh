#!/bin/bash
source ${rpc_lib_base_path}/rpc_message_stream.sh
source ${rpc_lib_base_path}/proto_parser/proto_rpc_meta.sh
source ${rpc_lib_base_path}/proto_parser/proto_rpc_message.sh
source ${rpc_lib_base_path}/rpc_echo_service.sh
function SSHandleMsg {
	local rpc_request=${1}
	local header_len=$(MSHeaderLen)
	local rpc_context=${rpc_request:${header_len}}

	local meta=$(proto_rpc_message_get_meta ${rpc_context})
	local data=$(proto_rpc_message_get_data ${rpc_context})
	local type=$(proto_rpc_meta_get_type ${meta})

	case ${type} in
	${RPC_CONTROL_REQUEST})
	    ExecuteControlCommand ${meta} ${data} 
		return $?
	;;
	${RPC_SERVICE_REQUEST})
	    InvokeServiceMethod ${meta} ${data} 
		return ${RPC_FLOW_CONTINUE}
	;;
    ${RPC_SERVICE_RESPONSE})
	    InvokeServiceCallbackMethod ${meta} ${data}
        return ${RPC_FLOW_CONTINUE}		
	;;
	esac
}
function InvokeServiceCallbackMethod {
	local meta=${1}
	local data=${2}
	local source_ip=$(proto_rpc_meta_get_source_ip ${meta})
	local method=$(proto_rpc_meta_get_method ${meta})
	local sequence_no=$(proto_rpc_meta_get_sequence_no ${meta})
	local method_result=$(${method} ${data})
}
function InvokeServiceMethod {
	local meta=${1}
	local data=${2}
	local source_ip=$(proto_rpc_meta_get_source_ip ${meta})
	local callback_port=$(proto_rpc_meta_get_callback_port ${meta})
	local method=$(proto_rpc_meta_get_method ${meta})
	local callback_method=$(proto_rpc_meta_get_callback_method ${meta})
	local sequence_no=$(proto_rpc_meta_get_sequence_no ${meta})

	local method_result=$(${method} ${data})
	local response_message=$(SSMakeRPCResponse ${RPC_SERVICE_RESPONSE} \
		${sequence_no} ${callback_method} ${method_result})

	local callback_ip=$(HexIPToDec ${source_ip})
	local callback_port=$(HexPortToDec ${callback_port})
	
	SendByteStream ${callback_ip} ${callback_port} ${sequence_no} ${response_message}
	if [ $? -ne ${RPC_SUCCESS} ];then
		return ${RPC_FAIL}
	fi
	return ${RPC_SUCCESS}
}
function SSMakeRPCResponse {
	local op_type=${1}
	local seq_no=${2}
	local callback_method=${3}
	local method_result=${4}
	
	local meta=$(proto_rpc_meta_make)
	meta=$(proto_rpc_meta_put_type ${meta} ${op_type})
	meta=$(proto_rpc_meta_put_sequence_no ${meta} ${seq_no})
	local local_ip_hex=$(IONetGetLocalIPHex)
	meta=$(proto_rpc_meta_put_source_ip ${meta} ${local_ip_hex})
	local port_hex=$(printf "%04x" 0)
	meta=$(proto_rpc_meta_put_callback_port ${meta} ${port_hex})
	meta=$(proto_rpc_meta_put_method ${meta} ${callback_method})
	meta=$(proto_rpc_meta_put_timeout ${meta} "0000")
	
	local meta_len=$(printf "%0${RPC_META_SIZE_HEX_WIDTH}x" ${#meta})
	local data_len=$(printf "%0${RPC_DATA_SIZE_HEX_WIDTH}x" ${#method_result})
	local header=$(SSMakeRPCResponseHeader ${meta_len} ${data_len})
	
	local response_message=$(proto_rpc_message_make)
	response_message=$(proto_rpc_message_put_meta ${response_message} ${meta})
	response_message=$(proto_rpc_message_put_data ${response_message} ${method_result})

	echo "${header}${response_message}"
}
function SSMakeRPCResponseHeader {
	local meta_len=${1}
	local data_len=${2}
    echo "${RPC_MESSAGE_MAGIC_NUM}${meta_len}${data_len}"	
}
