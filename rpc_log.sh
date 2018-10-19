#!/bin/bash
source ${rpc_lib_base_path}/rpc_def.sh
function RPCLog {
	local log=${1}
	echo ${log} >>${RPC_LOG_FILE}
}
