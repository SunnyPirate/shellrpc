#!/bin/bash
source ${rpc_cg_base_path}/rpc_def.sh 
function GenerateFieldParser {
	local proto_parser_path=${1}
	local proto_name=${2}
	local field_name=${3}
	local idx=${4}
	local version_magic_num=${5}
	local field_meta_pos=0

	sed -i 's/PROTO_NAME/'"${proto_name}"'/g'  \
		${proto_parser_path} 
	sed -i 's/PROTO_FIELD_NAME/'"${field_name}"'/g' \
		${proto_parser_path}

	let "field_meta_pos=RPC_PROTO_HEADER_META_LEN+8*(idx-1)"
	sed -i 's/PROTO_FIELD_META_POS_D/'"${field_meta_pos}"'/g' \
		${proto_parser_path}

	let "field_meta_pos+=4"
	sed -i 's/PROTO_FIELD_META_LEN_D/'"${field_meta_pos}"'/g' \
		${proto_parser_path}

	if [ 1 -eq ${idx} ];then
		field_meta_pos=${RPC_PROTO_HEADER_META_LEN}
	else
		let "field_meta_pos=RPC_PROTO_HEADER_META_LEN+8*(idx-2)"
	fi
	sed -i 's/PROTO_PRE_FIELD_META_POS_D/'"${field_meta_pos}"'/g' \
		${proto_parser_path}

	let "field_meta_pos+=4"
	sed -i 's/PROTO_PRE_FIELD_META_LEN_D/'"${field_meta_pos}"'/g'  \
		${proto_parser_path}
    	
	let "feild_meta_pos=RPC_PROTO_HEADER_META_LEN+8*idx"
	sed -i 's/PROTO_NEXT_FIELD_META_POS_D/'"${field_meta_pos}"'/g'  \
		${proto_parser_path}

	sed -i 's/PROTO_FIELD_IDX/'"${idx}"'/g' \
		${proto_parser_path}
	sed -i 's/PROTO_VERSION_MAGIC_NUM/'"${version_magic_num}"'/g' \
		${proto_parser_path}
}
function EchoHeaderToParser {
	local proto_parser_path=${1}
	local proto_name=${2}
	echo "#!/bin/bash" > ${proto_parser_path}
	echo -e "#[Proto] ${proto_name} parser don't edit it\n" >> ${proto_parser_path}
	echo "source \${rpc_lib_base_path}/rpc_common.sh" >> ${proto_parser_path}

}
function GenerateProtoParser {
    local proto_file=${1}
	if [ ! -f ${proto_file} ];then
		echo "[ERROR] no available proto file with path=${proto_file}"
	fi

	local work_path="${rpc_cg_base_path}/proto_parser/"
	mkdir -p ${work_path}
	local proto_name=`echo ${proto_file##*/}|cut -d"." -f1`
	
	local proto_parser_path=${work_path}/proto_${proto_name}.sh
	>${proto_parser_path}
    EchoHeaderToParser ${proto_parser_path} ${proto_name}

	local rw_tpl="${rpc_cg_base_path}/rpc_proto_rw_tpl.sh"
	local proto_parser_tmp_path=${proto_parser_path}.tmp

	local version_magic_num=$(CreateRandomStr 8)
	local field_name="unknown"
    local field_idx=1
	while read proto_line
	do
	    field_name=`echo ${proto_line}|cut -d":" -f1`	
	    cp -f ${rw_tpl} ${proto_parser_tmp_path}
		GenerateFieldParser \
			${proto_parser_tmp_path} \
			${proto_name} \
			${field_name} \
			${field_idx} \
			${version_magic_num}
		if [ ${RPC_SUCCESS} -ne $? ];then
			echo "[ERROR] generate filed[${field_name}] parser fail"
			rm -rf ${prpto_parser_tmp_path}
			return ${RPC_FAIL}
		else
			cat ${proto_parser_tmp_path} >> ${proto_parser_path}
		fi
		let "field_idx++"
	done < ${proto_file}
	
	let "field_idx--"
	sed -i 's/PROTO_FIELD_COUNT_D/'"${field_idx}"'/g'  ${proto_parser_path}
	
	local make_tpl="${rpc_cg_base_path}/rpc_proto_make_tpl.sh"
	cp -f ${make_tpl} ${proto_parser_tmp_path} 
	let "field_default_pos=RPC_PROTO_HEADER_META_LEN+8*field_idx"
	local field_default_pos_h=$(DecToHex 4 ${field_default_pos})
	
	sed -i 's/PROTO_FIELD_COUNT_D/'"${field_idx}"'/g'  ${proto_parser_tmp_path}
	sed -i 's/PROTO_NAME/'"${proto_name}"'/g'  ${proto_parser_tmp_path}
	sed -i 's/PROTO_FIELD_DEFAULT_POS/'"${field_default_pos_h}"'/g'  ${proto_parser_tmp_path}
	sed -i 's/PROTO_VERSION_MAGIC_NUM/'"${version_magic_num}"'/g'  ${proto_parser_tmp_path}
	cat ${proto_parser_tmp_path} >> ${proto_parser_path}
	rm -rf ${proto_parser_tmp_path}
	return ${RPC_SUCCESS}
}
