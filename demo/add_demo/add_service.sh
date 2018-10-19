source ${rpc_lib_base_path}/proto_parser/proto_add_request.sh
source ${rpc_lib_base_path}/proto_parser/proto_add_response.sh
function AddService {
	local request=${1}
    local param1=$(proto_add_request_get_param1 ${request})
    local param2=$(proto_add_request_get_param2 ${request})
	local sum=0
	let "sum=param1+param2"
	
	local response=$(proto_add_response_make)
	response=$(proto_add_response_put_sum ${response} ${sum})
	local time_stamp=`date +%s`
	RPCLog "[INFO]AddService ${time_stamp}"

	echo ${response}
} 
function AddServiceCallback {
	local response=${1}
    local message=$(proto_add_response_get_sum ${response})
	RPCLog "[INFO]AddService return ${message}"
}

