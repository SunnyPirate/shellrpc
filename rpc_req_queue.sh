#!/bin/bash
declare -A QueueMetaInfo=()
function GetRandomQueueName {
	local random_str="`cat /dev/urandom|head -n 10|md5sum|\
		awk '{print $1}'|head -c 12`"
    echo "rpc_req_queue_${random_str}"
}
function GetRandomFD {
    local random=$(GetRangeRandom 10 99)	
	echo ${random}
}
function CreateReqQueue {
	local queue_name=${1}
	local fifo_path="/tmp/${queue_name}"
	local fifo_fd=$(GetRandomFD)
	mkfifo ${fifo_path}
	eval "QueueMetaInfo["${queue_name}"]=${fifo_fd}"
	eval "exec ${fifo_fd}<>${fifo_path}"
}
function GetReqQueueFD {
	local fifo_name=${1}
	local fifo_fd=${QueueMetaInfo["${fifo_name}"]}
	echo ${fifo_fd}
}
function BindQueueFD {
	local fd=${1}
    local fifo_path=${2}
	eval "exec ${fd}<>${fifo_path}"
}
