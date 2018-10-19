#/bin/bash
function SendByteStream {
	local remote_addr=${1}
	local remote_port=${2}
	local seq_no=${3}
	local data=${4}
	IOSyncSendByte ${remote_addr} ${remote_port} ${seq_no} ${data}
	return $?
}

