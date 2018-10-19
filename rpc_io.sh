#!/bin/bash
source ${rpc_lib_base_path}/rpc_def.sh
function IONetGetLocalIPDec {
	local local_ip=`ifconfig|grep -A 1 eth0 |grep inet|awk '{print $2}'`
	echo ${local_ip}
}
function IONetGetLocalIPHex {
	local local_ip_str=$(IONetGetLocalIPDec)
	local ip_in_hex=""
	for idx in $(seq 4)
	do
		dec=`echo ${local_ip_str}|\
		awk -v i=${idx} -F"." '{print $i}'`
		hex=$(printf "%02x" ${dec})
		ip_in_hex="${ip_in_hex}${hex}"
	done
	echo ${ip_in_hex}
}
function IOCheckNetPortState {
	local port=${1}
	local port_info=$(lsof -i:${port}|grep "(LISTEN)$")
	if [ -n "${port_info}" ];then
		return ${RPC_PORT_LISTEN}
	fi
	return ${RPC_PORT_FREE}
}
function IOSyncSendByte {
    local remote_addr=${1}
	local remote_port=${2}
    local seq_no=${3}
	local data=${4}
	echo "${data}"|nc ${remote_addr} ${remote_port}
	case $? in
	0)
		RPCLog "[INFO][${seq_no}] RPC \
			${remote_addr}:${remote_port} success"
		return ${RPC_SUCCESS}
	;;
    1) 
		RPCLog "[ERROR][${seq_no}] RPC \
			Connection Refused ${remote_addr}:${remote_port}"
		return ${RPC_FAIL}
	;;
    *)
		RPCLog "[ERROR][${seq_no}] RPC \
			Net error ${remote_addr}:${remote_port}"
		return ${RPC_FAIL}
	;;
	esac
}
function IOCreateListener {
	local addr=${1}
	local port=${2}
    IOCheckNetPortState ${port}
	if [ ${RPC_PORT_FREE} -eq $? ];then
		echo "nc --keep-open --listen ${addr} ${port}"
	else
		echo ""
	fi
}
