#!/bin/bash
#[Proto] stop_request parser don't edit it

source ${rpc_lib_base_path}/rpc_common.sh
function proto_stop_request_get_role {
	local proto_data=${1}
	proto_stop_request_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto stop_request unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:10:4}
	local field_data_len_h=${proto_data:14:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_stop_request_put_role {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_stop_request_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto stop_request unmatch version"
		echo ""
		return
	fi
    proto_field_data=$(ProtoEncode "${proto_field_data}")
	local field_data_len_d=${#proto_field_data}
	local field_data_len_h=$(DecToHex 4 ${field_data_len_d})

	local pre_field_data_pos_h=${proto_data:10:4}
	local pre_field_data_len_h=${proto_data:14:4}

	local pre_field_data_pos_d=$(HexToDec ${pre_field_data_pos_h})
	local pre_field_data_len_d=$(HexToDec  ${pre_field_data_len_h})


    let "field_data_pos_d=pre_field_data_pos_d+pre_field_data_len_d"
	local field_data_pos_h=$(DecToHex 4 ${field_data_pos_d})

	local new_data=${proto_data:0:10}
	new_data="${new_data}${field_data_pos_h}${field_data_len_h}"

	local field_pos_h=0
	local field_pos_d=0
	local field_len_h=0
	local field_len_d=0
	local field_meta_pos=0
	let "field_meta_pos=10+8"
	let "field_pos_d=field_data_pos_d+field_data_len_d"

	for ((loop=1;loop<5;loop++))
	do
		field_pos_h=$(DecToHex 4 ${field_pos_d})
		new_data=${new_data}${field_pos_h}
        let "field_meta_pos+=4"
	    field_len_h=${proto_data:${field_meta_pos}:4}
	    field_len_d=$(HexToDec ${field_len_h})
	    let "field_pos_d=field_pos_d+field_len_d"
		new_data=${new_data}${field_len_h}
        let "field_meta_pos+=4"
	done

	let "seg_len=field_data_pos_d-field_meta_pos"
	new_data=${new_data}${proto_data:${field_meta_pos}:${seg_len}}
	new_data=${new_data}${proto_field_data}
    if [ 1 -lt 5 ];then	
	    let "field_meta_pos=10+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
function proto_stop_request_get_token {
	local proto_data=${1}
	proto_stop_request_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto stop_request unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:18:4}
	local field_data_len_h=${proto_data:22:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_stop_request_put_token {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_stop_request_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto stop_request unmatch version"
		echo ""
		return
	fi
    proto_field_data=$(ProtoEncode "${proto_field_data}")
	local field_data_len_d=${#proto_field_data}
	local field_data_len_h=$(DecToHex 4 ${field_data_len_d})

	local pre_field_data_pos_h=${proto_data:10:4}
	local pre_field_data_len_h=${proto_data:14:4}

	local pre_field_data_pos_d=$(HexToDec ${pre_field_data_pos_h})
	local pre_field_data_len_d=$(HexToDec  ${pre_field_data_len_h})


    let "field_data_pos_d=pre_field_data_pos_d+pre_field_data_len_d"
	local field_data_pos_h=$(DecToHex 4 ${field_data_pos_d})

	local new_data=${proto_data:0:18}
	new_data="${new_data}${field_data_pos_h}${field_data_len_h}"

	local field_pos_h=0
	local field_pos_d=0
	local field_len_h=0
	local field_len_d=0
	local field_meta_pos=0
	let "field_meta_pos=18+8"
	let "field_pos_d=field_data_pos_d+field_data_len_d"

	for ((loop=2;loop<5;loop++))
	do
		field_pos_h=$(DecToHex 4 ${field_pos_d})
		new_data=${new_data}${field_pos_h}
        let "field_meta_pos+=4"
	    field_len_h=${proto_data:${field_meta_pos}:4}
	    field_len_d=$(HexToDec ${field_len_h})
	    let "field_pos_d=field_pos_d+field_len_d"
		new_data=${new_data}${field_len_h}
        let "field_meta_pos+=4"
	done

	let "seg_len=field_data_pos_d-field_meta_pos"
	new_data=${new_data}${proto_data:${field_meta_pos}:${seg_len}}
	new_data=${new_data}${proto_field_data}
    if [ 2 -lt 5 ];then	
	    let "field_meta_pos=18+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
function proto_stop_request_get_round_idx {
	local proto_data=${1}
	proto_stop_request_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto stop_request unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:26:4}
	local field_data_len_h=${proto_data:30:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_stop_request_put_round_idx {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_stop_request_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto stop_request unmatch version"
		echo ""
		return
	fi
    proto_field_data=$(ProtoEncode "${proto_field_data}")
	local field_data_len_d=${#proto_field_data}
	local field_data_len_h=$(DecToHex 4 ${field_data_len_d})

	local pre_field_data_pos_h=${proto_data:18:4}
	local pre_field_data_len_h=${proto_data:22:4}

	local pre_field_data_pos_d=$(HexToDec ${pre_field_data_pos_h})
	local pre_field_data_len_d=$(HexToDec  ${pre_field_data_len_h})


    let "field_data_pos_d=pre_field_data_pos_d+pre_field_data_len_d"
	local field_data_pos_h=$(DecToHex 4 ${field_data_pos_d})

	local new_data=${proto_data:0:26}
	new_data="${new_data}${field_data_pos_h}${field_data_len_h}"

	local field_pos_h=0
	local field_pos_d=0
	local field_len_h=0
	local field_len_d=0
	local field_meta_pos=0
	let "field_meta_pos=26+8"
	let "field_pos_d=field_data_pos_d+field_data_len_d"

	for ((loop=3;loop<5;loop++))
	do
		field_pos_h=$(DecToHex 4 ${field_pos_d})
		new_data=${new_data}${field_pos_h}
        let "field_meta_pos+=4"
	    field_len_h=${proto_data:${field_meta_pos}:4}
	    field_len_d=$(HexToDec ${field_len_h})
	    let "field_pos_d=field_pos_d+field_len_d"
		new_data=${new_data}${field_len_h}
        let "field_meta_pos+=4"
	done

	let "seg_len=field_data_pos_d-field_meta_pos"
	new_data=${new_data}${proto_data:${field_meta_pos}:${seg_len}}
	new_data=${new_data}${proto_field_data}
    if [ 3 -lt 5 ];then	
	    let "field_meta_pos=26+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
function proto_stop_request_get_max_round_idx {
	local proto_data=${1}
	proto_stop_request_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto stop_request unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:34:4}
	local field_data_len_h=${proto_data:38:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_stop_request_put_max_round_idx {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_stop_request_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto stop_request unmatch version"
		echo ""
		return
	fi
    proto_field_data=$(ProtoEncode "${proto_field_data}")
	local field_data_len_d=${#proto_field_data}
	local field_data_len_h=$(DecToHex 4 ${field_data_len_d})

	local pre_field_data_pos_h=${proto_data:26:4}
	local pre_field_data_len_h=${proto_data:30:4}

	local pre_field_data_pos_d=$(HexToDec ${pre_field_data_pos_h})
	local pre_field_data_len_d=$(HexToDec  ${pre_field_data_len_h})


    let "field_data_pos_d=pre_field_data_pos_d+pre_field_data_len_d"
	local field_data_pos_h=$(DecToHex 4 ${field_data_pos_d})

	local new_data=${proto_data:0:34}
	new_data="${new_data}${field_data_pos_h}${field_data_len_h}"

	local field_pos_h=0
	local field_pos_d=0
	local field_len_h=0
	local field_len_d=0
	local field_meta_pos=0
	let "field_meta_pos=34+8"
	let "field_pos_d=field_data_pos_d+field_data_len_d"

	for ((loop=4;loop<5;loop++))
	do
		field_pos_h=$(DecToHex 4 ${field_pos_d})
		new_data=${new_data}${field_pos_h}
        let "field_meta_pos+=4"
	    field_len_h=${proto_data:${field_meta_pos}:4}
	    field_len_d=$(HexToDec ${field_len_h})
	    let "field_pos_d=field_pos_d+field_len_d"
		new_data=${new_data}${field_len_h}
        let "field_meta_pos+=4"
	done

	let "seg_len=field_data_pos_d-field_meta_pos"
	new_data=${new_data}${proto_data:${field_meta_pos}:${seg_len}}
	new_data=${new_data}${proto_field_data}
    if [ 4 -lt 5 ];then	
	    let "field_meta_pos=34+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
function proto_stop_request_get_bind_port {
	local proto_data=${1}
	proto_stop_request_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto stop_request unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:42:4}
	local field_data_len_h=${proto_data:46:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_stop_request_put_bind_port {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_stop_request_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto stop_request unmatch version"
		echo ""
		return
	fi
    proto_field_data=$(ProtoEncode "${proto_field_data}")
	local field_data_len_d=${#proto_field_data}
	local field_data_len_h=$(DecToHex 4 ${field_data_len_d})

	local pre_field_data_pos_h=${proto_data:34:4}
	local pre_field_data_len_h=${proto_data:38:4}

	local pre_field_data_pos_d=$(HexToDec ${pre_field_data_pos_h})
	local pre_field_data_len_d=$(HexToDec  ${pre_field_data_len_h})


    let "field_data_pos_d=pre_field_data_pos_d+pre_field_data_len_d"
	local field_data_pos_h=$(DecToHex 4 ${field_data_pos_d})

	local new_data=${proto_data:0:42}
	new_data="${new_data}${field_data_pos_h}${field_data_len_h}"

	local field_pos_h=0
	local field_pos_d=0
	local field_len_h=0
	local field_len_d=0
	local field_meta_pos=0
	let "field_meta_pos=42+8"
	let "field_pos_d=field_data_pos_d+field_data_len_d"

	for ((loop=5;loop<5;loop++))
	do
		field_pos_h=$(DecToHex 4 ${field_pos_d})
		new_data=${new_data}${field_pos_h}
        let "field_meta_pos+=4"
	    field_len_h=${proto_data:${field_meta_pos}:4}
	    field_len_d=$(HexToDec ${field_len_h})
	    let "field_pos_d=field_pos_d+field_len_d"
		new_data=${new_data}${field_len_h}
        let "field_meta_pos+=4"
	done

	let "seg_len=field_data_pos_d-field_meta_pos"
	new_data=${new_data}${proto_data:${field_meta_pos}:${seg_len}}
	new_data=${new_data}${proto_field_data}
    if [ 5 -lt 5 ];then	
	    let "field_meta_pos=42+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
function proto_stop_request_make {
	local meta=5c4e0fe5
	local field_count_h=$(DecToHex 2 5)
	meta=${meta}${field_count_h}
	for((loop=0; loop<5;loop++))
	do
		meta=${meta}"00320000"
	done
	echo ${meta}
}
function proto_stop_request_check_valid {
    local proto_data=${1}	
	local version_magic_num=${proto_data:0:8}
    if [ "5c4e0fe5" == "${version_magic_num}" ];then
		return ${RPC_SUCCESS}
	else
        return ${RPC_FAIL}	
	fi
}
