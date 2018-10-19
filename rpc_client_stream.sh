#!/bin/bash
source ${rpc_lib_base_path}/proto_parser/proto_rpc_meta.sh
source ${rpc_lib_base_path}/proto_parser/proto_rpc_message.sh

function CSMakeRPCRequest {
	local op_type=${1}
	local remote_method=${2}
	local callback_method=${3}
	local seq_no=${4}
	local callback_port=${5}
	local request_context=${6}
	
	local meta=$(proto_rpc_meta_make)
	meta=$(proto_rpc_meta_put_type ${meta} ${op_type})
	meta=$(proto_rpc_meta_put_sequence_no ${meta} ${seq_no})
	local local_ip_hex=$(IONetGetLocalIPHex)
	meta=$(proto_rpc_meta_put_source_ip ${meta} ${local_ip_hex})
	local port_hex=$(printf "%04x" ${callback_port})
	meta=$(proto_rpc_meta_put_callback_port ${meta} ${port_hex})
	meta=$(proto_rpc_meta_put_method ${meta} ${remote_method})
	meta=$(proto_rpc_meta_put_callback_method ${meta} ${callback_method})
	meta=$(proto_rpc_meta_put_timeout ${meta} "0000")
	
	local meta_len=$(printf "%0${RPC_META_SIZE_HEX_WIDTH}x" ${#meta})
	local data_len=$(printf "%0${RPC_DATA_SIZE_HEX_WIDTH}x" ${#request_context})
	local header=$(CSMakeRPCRequestHeader ${meta_len} ${data_len})
	
	local request_message=$(proto_rpc_message_make)
	request_message=$(proto_rpc_message_put_meta ${request_message} ${meta})
	request_message=$(proto_rpc_message_put_data ${request_message} ${request_context})
	echo "${header}${request_message}"
}
function CSMakeRPCRequestHeader {
	local meta_len=${1}
	local data_len=${2}
    echo "${RPC_MESSAGE_MAGIC_NUM}${meta_len}${data_len}"	
}
