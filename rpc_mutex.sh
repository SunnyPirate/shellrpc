#!/bin/bash
source ${rpc_lib_base_path}/rpc_common.sh
declare -A MutexLockMetaInfo=()
function GetRandomMutexName {
	local r_str=$(CreateRandomStr 6)
	local lock_name="mutex_${r_str}_lock"
	echo ${lock_name}
}
function CreateMutex {
	local lock_name=${1}
	local fifo_path="/tmp/${lock_name}"
	local lock_fd=$(GetRangeRandom 10 99)
	mkfifo ${fifo_path}
	eval "MutexLockMetaInfo["${lock_name}"]=${lock_fd}"
	eval "exec ${lock_fd}<>${fifo_path}"
    echo >&${lock_fd}
}
function AttachMutex {
	local lock_name=${1}
    local lock_path="/tmp/${lock_name}"
	local mutex_fd=${MutexLockMetaInfo["${lock_name}"]}
	eval "exec ${mutex_fd}<>${lock_path}"
}
function MutexLock {
	local lock_name=${1}
	local mutex_fd=${MutexLockMetaInfo["${lock_name}"]}
    read -u${mutex_fd}	
	return 
}
function MutexUnLock {
	local lock_name=${1}
	local mutex_fd=${MutexLockMetaInfo["${lock_name}"]}
    echo >&${mutex_fd}
	return 
}
