function proto_PROTO_NAME_make {
	local meta=PROTO_VERSION_MAGIC_NUM
	local field_count_h=$(DecToHex 2 PROTO_FIELD_COUNT_D)
	meta=${meta}${field_count_h}
	for((loop=0; loop<PROTO_FIELD_COUNT_D;loop++))
	do
		meta=${meta}"PROTO_FIELD_DEFAULT_POS0000"
	done
	echo ${meta}
}
function proto_PROTO_NAME_check_valid {
    local proto_data=${1}	
	local version_magic_num=${proto_data:0:8}
    if [ "PROTO_VERSION_MAGIC_NUM" == "${version_magic_num}" ];then
		return ${RPC_SUCCESS}
	else
        return ${RPC_FAIL}	
	fi
}
