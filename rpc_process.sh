#/bin/bash
function CreateHandleMsgProcess {
	local process_num=${1}
	local mutex_lock=${2}
	local req_queue=${3}
	local work_mode=${4}
	for((idx=0;idx<${process_num};idx++))
	do
		HandleMsgProcess ${idx} ${mutex_lock} ${req_queue} ${work_mode} &
	done
	
}
function HandleMsgProcess {
	local process_idx=${1}
	local mutex_lock=${2}
	local req_queue=${3}
	local work_mode=${4}
	local req_byte_stream=""
	#AttachMutex ${mutex_lock}
	#BindQueueFD ${bind_queue_fd} ${req_queue_path}
	local queue_fd=$(GetReqQueueFD ${req_queue})
	local result=${RPC_FLOW_CONTINUE}

	while true;
	do
		MutexLock ${mutex_lock}
		read -u${queue_fd} req_byte_stream 
		MutexUnLock ${mutex_lock}

		SSHandleMsg ${req_byte_stream}
		result=$?
		if [ ${RPC_PROCESSOR_FLOW_STOP} -eq ${result} ];then
			break
		fi
	done
	RPCLog "[INFO] HandleReqProcess[${process_idx}] normal exit"
}
function CreateListenProcess {
	local listener=${1}
	local req_queue=${2}
    ListenProcess "${listener}" ${req_queue}  &
}
function ListenProcess {
	local listener=${1}
	local req_queue=${2}
	local queue_fd=$(GetReqQueueFD ${req_queue})

    ${listener}	|\
	while read rpc_byte_request
	do
		MSIsValidMessage ${rpc_byte_request}
		if [ ${RPC_FALSE} -eq $? ];then
			continue
		fi
		echo ${rpc_byte_request} >&${queue_fd}
	done
	RPCLog "[INFO] ListenProcess normal exit"
} 
function CreateProcessUnit {
	local listen_port=${1}
	local processor_num=${2}
	local work_mode=${3}

	local queue_mutex_lock=$(GetRandomMutexName)
	CreateMutex ${queue_mutex_lock}
	
	local req_queue_name=$(GetRandomQueueName)
	CreateReqQueue ${req_queue_name}
	
	local local_ip=$(IONetGetLocalIPDec)
	local listener="$(IOCreateListener ${local_ip} ${listen_port})"
	if [ -z "${listener}" ];then
		return ${RPC_FAIL}
	fi
	CreateListenProcess "${listener}" ${req_queue_name}
	RPCLog "[INFO] CreateListenProcess done"
	CreateHandleMsgProcess ${processor_num} ${queue_mutex_lock} ${req_queue_name} ${work_mode}
	RPCLog "[INFO] CreateHandleMsgProcess done"
}

