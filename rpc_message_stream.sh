#!/in/bash
source ${rpc_lib_base_path}/rpc_def.sh 
function MSIsValidMessage {
	local data=${1}
	local data_len=${#data}
    local magic_num_len=${#RPC_MESSAGE_MAGIC_NUM}	
	if [ ${data_len} -lt ${magic_num_len} ];then
		return ${RPC_FALSE} 
	fi
	local magic_num=${data:0:${magic_num_len}}
	if [ ${magic_num} -ne ${RPC_MESSAGE_MAGIC_NUM} ];then
		return ${RPC_FALSE}
	fi
	let "size_info_len=RPC_META_SIZE_HEX_WIDTH+RPC_DATA_SIZE_HEX_WIDTH"
	local size_info=${data:${magic_num_len}:${size_info_len}}
	if [ ${#size_info} -lt ${size_info_len} ];then
		return ${RPC_FALSE}
	fi 
    let "meta_pos=magic_num_len+size_info_len"
	local meta_size_width=${RPC_META_SIZE_HEX_WIDTH}
	local data_size_width=${RPC_DATA_SIZE_HEX_WIDTH}
	local meta_len_h=${size_info:0:${meta_size_width}}
	local data_len_h=${size_info:${meta_size_width}:${data_size_width}}
	local meta_len_o=$((16#${meta_len_h}))
	local data_len_o=$((16#${data_len_h}))
	let "expect_info_len=meta_len_o+data_len_o"
	let "recv_info_len=data_len-magic_num_len-size_info_len"
	if [ ${expect_info_len} -gt ${recv_info_len} ];then
		return ${RPC_FALSE}
	fi
	return ${RPC_TRUE}
}
function MSHeaderLen {
    local magic_num_len=${#RPC_MESSAGE_MAGIC_NUM}	
	let "header_len=magic_num_len+RPC_META_SIZE_HEX_WIDTH\
			+RPC_DATA_SIZE_HEX_WIDTH"
	echo ${header_len}
}

