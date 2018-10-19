#!/bin/bash
function GetSeqNo {
	local random_str="`cat /dev/urandom|head -n 10|md5sum|\
		awk '{print $1}'|head -c 16`"
    echo ${random_str}
}
function GetRangeRandom {
	local min=${1}
	local max=$(($2-${min}+1))
	local num=$((${RANDOM}+1000000000))
	echo $((${num}%${max}+${min}))
}
function CreateRandomStr {
	local str_max_len=${1}
	local random_str="`cat /dev/urandom|head -n 10|md5sum|\
		awk '{print $1}'|head -c ${str_max_len}`"
    echo ${random_str}
}
function GetValueFromVar {
	local var=${1}
	local res=`eval "echo ${var}"`
	local value=`eval "echo  ${res}"`
	echo ${value}
}
function HexIPToDec {
	local ip_hex_str=${1}
	local pos=0
	if [ ${#ip_hex_str} -ne 8 ];then
		echo ""
	fi
	local section=""
	local res=""
	for idx in $(seq 0 3)
	do
		let "pos=idx*2"
		section=${ip_hex_str:${pos}:2}
		section_dec=$(printf "%d" 0x${section})
		if [ ${idx} -ne 0 ];then
		    res="${res}.${section_dec}"
		else
			res=${section_dec}
		fi
	done
	echo ${res} 
}
function HexToDec {
	local hex=${1}
	local dec=$(printf "%d" 0x${hex})
	echo ${dec}
}
function DecToHex {
	local seg=${1}
	local dec=${2}
	local hex=$(printf "%0${seg}x" ${dec})
	echo ${hex}
}
function HexPortToDec {
	local hex_port=${1}
    local dec_port=$(printf "%d" 0x${hex_port})
	echo ${dec_port}
}
function HexToStr {
	if [ $# -ne 2 ];then
		echo ""
	fi
	local tag=${1}
	local num=${2}
	local res=$(printf "%0${tag}x" ${num})
	echo ${res}
}
function ProtoEncode {
	local proto_data=${1}
	local encode_data=`echo ${proto_data}|base64 -w 0`
	echo ${encode_data}
}
function ProtoDecode {
	local proto_data=${1}
	local decode_data=`echo ${proto_data}|base64 -d -w 0`
	echo ${decode_data}
}

