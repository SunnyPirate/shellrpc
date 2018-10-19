function proto_PROTO_NAME_get_PROTO_FIELD_NAME {
	local proto_data=${1}
	proto_PROTO_NAME_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto PROTO_NAME unmatch version"
		echo ""
		return
	fi
	
	local field_data_pos_h=${proto_data:PROTO_FIELD_META_POS_D:4}
	local field_data_len_h=${proto_data:PROTO_FIELD_META_LEN_D:4}
	local field_data_pos_d=$(HexToDec ${field_data_pos_h})
	local field_data_len_d=$(HexToDec ${field_data_len_h})
	ProtoDecode "${proto_data:${field_data_pos_d}:${field_data_len_d}}"
}
function proto_PROTO_NAME_put_PROTO_FIELD_NAME {
	local proto_data=${1}
	local proto_field_data=${2}
	proto_PROTO_NAME_check_valid ${proto_data}
	if [ ${RPC_FAIL} -eq $? ];then
		RPCLog "[ERROR] proto PROTO_NAME unmatch version"
		echo ""
		return
	fi
    proto_field_data=$(ProtoEncode "${proto_field_data}")
	local field_data_len_d=${#proto_field_data}
	local field_data_len_h=$(DecToHex 4 ${field_data_len_d})

	local pre_field_data_pos_h=${proto_data:PROTO_PRE_FIELD_META_POS_D:4}
	local pre_field_data_len_h=${proto_data:PROTO_PRE_FIELD_META_LEN_D:4}

	local pre_field_data_pos_d=$(HexToDec ${pre_field_data_pos_h})
	local pre_field_data_len_d=$(HexToDec  ${pre_field_data_len_h})


    let "field_data_pos_d=pre_field_data_pos_d+pre_field_data_len_d"
	local field_data_pos_h=$(DecToHex 4 ${field_data_pos_d})

	local new_data=${proto_data:0:PROTO_FIELD_META_POS_D}
	new_data="${new_data}${field_data_pos_h}${field_data_len_h}"

	local field_pos_h=0
	local field_pos_d=0
	local field_len_h=0
	local field_len_d=0
	local field_meta_pos=0
	let "field_meta_pos=PROTO_FIELD_META_POS_D+8"
	let "field_pos_d=field_data_pos_d+field_data_len_d"

	for ((loop=PROTO_FIELD_IDX;loop<PROTO_FIELD_COUNT_D;loop++))
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
    if [ PROTO_FIELD_IDX -lt PROTO_FIELD_COUNT_D ];then	
	    let "field_meta_pos=PROTO_FIELD_META_POS_D+8"
	    local next_field_data_pos_h=${proto_data:${field_meta_pos}:4}
  	    local next_field_data_pos_d=$(HexToDec ${next_field_data_pos_h})
	    new_data="${new_data}${proto_data:${next_field_data_pos_d}}"
	fi
	echo ${new_data}
}
