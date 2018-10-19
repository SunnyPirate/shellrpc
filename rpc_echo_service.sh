#!/bin/bash
source ${rpc_lib_base_path}/proto_parser/proto_echo_request.sh
source ${rpc_lib_base_path}/proto_parser/proto_echo_response.sh
function EchoService {
	local request=${1}
    local name=$(proto_echo_request_get_name ${request})
	local response=$(proto_echo_response_make)
	response=$(proto_echo_response_put_message ${response} "Hello ${name}")
	local time_stamp=`date +%s`
	RPCLog "[INFO]EchoService ${time_stamp}"

	echo ${response}
} 
function EchoServiceCallback {
	local response=${1}
    local message=$(proto_echo_response_get_message ${response})
	RPCLog "[INFO]EchoService return ${message}"
	echo ""
}
