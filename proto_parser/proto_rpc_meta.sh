#!/bin/bash
#[Proto] rpc_meta parser don't edit it

source ${rpc_lib_base_path}/rpc_common.sh
function proto_rpc_meta_get_type {
	local proto_data=${1}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:10:4}
	local field_data_len_h=${proto_data:14:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_rpc_meta_put_type {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
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

	for ((loop=1;loop<7;loop++))
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
    if [ 1 -lt 7 ];then	
	    let "field_meta_pos=10+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
function proto_rpc_meta_get_sequence_no {
	local proto_data=${1}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:18:4}
	local field_data_len_h=${proto_data:22:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_rpc_meta_put_sequence_no {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
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

	for ((loop=2;loop<7;loop++))
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
    if [ 2 -lt 7 ];then	
	    let "field_meta_pos=18+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
function proto_rpc_meta_get_source_ip {
	local proto_data=${1}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:26:4}
	local field_data_len_h=${proto_data:30:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_rpc_meta_put_source_ip {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
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

	for ((loop=3;loop<7;loop++))
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
    if [ 3 -lt 7 ];then	
	    let "field_meta_pos=26+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
function proto_rpc_meta_get_method {
	local proto_data=${1}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:34:4}
	local field_data_len_h=${proto_data:38:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_rpc_meta_put_method {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
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

	for ((loop=4;loop<7;loop++))
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
    if [ 4 -lt 7 ];then	
	    let "field_meta_pos=34+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
function proto_rpc_meta_get_callback_port {
	local proto_data=${1}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:42:4}
	local field_data_len_h=${proto_data:46:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_rpc_meta_put_callback_port {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
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

	for ((loop=5;loop<7;loop++))
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
    if [ 5 -lt 7 ];then	
	    let "field_meta_pos=42+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
function proto_rpc_meta_get_callback_method {
	local proto_data=${1}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:50:4}
	local field_data_len_h=${proto_data:54:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_rpc_meta_put_callback_method {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
		echo ""
		return
	fi
    proto_field_data=$(ProtoEncode "${proto_field_data}")
	local field_data_len_d=${#proto_field_data}
	local field_data_len_h=$(DecToHex 4 ${field_data_len_d})

	local pre_field_data_pos_h=${proto_data:42:4}
	local pre_field_data_len_h=${proto_data:46:4}

	local pre_field_data_pos_d=$(HexToDec ${pre_field_data_pos_h})
	local pre_field_data_len_d=$(HexToDec  ${pre_field_data_len_h})


    let "field_data_pos_d=pre_field_data_pos_d+pre_field_data_len_d"
	local field_data_pos_h=$(DecToHex 4 ${field_data_pos_d})

	local new_data=${proto_data:0:50}
	new_data="${new_data}${field_data_pos_h}${field_data_len_h}"

	local field_pos_h=0
	local field_pos_d=0
	local field_len_h=0
	local field_len_d=0
	local field_meta_pos=0
	let "field_meta_pos=50+8"
	let "field_pos_d=field_data_pos_d+field_data_len_d"

	for ((loop=6;loop<7;loop++))
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
    if [ 6 -lt 7 ];then	
	    let "field_meta_pos=50+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
function proto_rpc_meta_get_timeout {
	local proto_data=${1}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:58:4}
	local field_data_len_h=${proto_data:62:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_rpc_meta_put_timeout {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_rpc_meta_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto rpc_meta unmatch version"
		echo ""
		return
	fi
    proto_field_data=$(ProtoEncode "${proto_field_data}")
	local field_data_len_d=${#proto_field_data}
	local field_data_len_h=$(DecToHex 4 ${field_data_len_d})

	local pre_field_data_pos_h=${proto_data:50:4}
	local pre_field_data_len_h=${proto_data:54:4}

	local pre_field_data_pos_d=$(HexToDec ${pre_field_data_pos_h})
	local pre_field_data_len_d=$(HexToDec  ${pre_field_data_len_h})


    let "field_data_pos_d=pre_field_data_pos_d+pre_field_data_len_d"
	local field_data_pos_h=$(DecToHex 4 ${field_data_pos_d})

	local new_data=${proto_data:0:58}
	new_data="${new_data}${field_data_pos_h}${field_data_len_h}"

	local field_pos_h=0
	local field_pos_d=0
	local field_len_h=0
	local field_len_d=0
	local field_meta_pos=0
	let "field_meta_pos=58+8"
	let "field_pos_d=field_data_pos_d+field_data_len_d"

	for ((loop=7;loop<7;loop++))
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
    if [ 7 -lt 7 ];then	
	    let "field_meta_pos=58+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
function proto_rpc_meta_make {
	local meta=3a993ed9
	local field_count_h=$(DecToHex 2 7)
	meta=${meta}${field_count_h}
	for((loop=0; loop<7;loop++))
	do
		meta=${meta}"00420000"
	done
	echo ${meta}
}
function proto_rpc_meta_check_valid {
    local proto_data=${1}	
	local version_magic_num=${proto_data:0:8}
    if [ "3a993ed9" == "${version_magic_num}" ];then
		return ${RPC_SUCCESS}
	else
        return ${RPC_FAIL}	
	fi
}
