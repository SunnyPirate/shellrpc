#!/bin/bash
rpc_cg_base_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" &&pwd)
source ${rpc_cg_base_path}/rpc_common.sh
source ${rpc_cg_base_path}/rpc_proto.sh

function ExecCmd {
	if [ $# -ne 1 ];then
		echo "[ERROR] need proto path"
		exit 1
	fi
	local proto_file_path=${1}
    GenerateProtoParser ${proto_file_path}
}
ExecCmd $@

