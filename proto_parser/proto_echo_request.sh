#!/bin/bash
#[Proto] echo_request parser don't edit it

source ${rpc_lib_base_path}/rpc_common.sh
function proto_echo_request_get_name {
	local proto_data=${1}
	proto_echo_request_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto echo_request unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:10:4}
	local field_data_len_h=${proto_data:14:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_echo_request_put_name {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_echo_request_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto echo_request unmatch version"
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

	for ((loop=1;loop<1;loop++))
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
    if [ 1 -lt 1 ];then	
	    let "field_meta_pos=10+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
function proto_echo_request_make {
	local meta=80ff535a
	local field_count_h=$(DecToHex 2 1)
	meta=${meta}${field_count_h}
	for((loop=0; loop<1;loop++))
	do
		meta=${meta}"00120000"
	done
	echo ${meta}
}
function proto_echo_request_check_valid {
    local proto_data=${1}	
	local version_magic_num=${proto_data:0:8}
    if [ "80ff535a" == "${version_magic_num}" ];then
		return ${RPC_SUCCESS}
	else
        return ${RPC_FAIL}	
	fi
}
