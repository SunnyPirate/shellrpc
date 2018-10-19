#!bin/bash
source ../../rpclib.sh
source ../../proto_parser/proto_add_request.sh
source ../../proto_parser/proto_add_response.sh
source ./add_service.sh

trap "ExitProcess" 2
module_running=0
function ExitProcess {
    StopRPCServer 8877 2
	wait
	module_running=1
}
function MainProcess {
	CreateRPCServer 8877 2
	if [ ${RPC_SUCCESS} -ne $? ];then
		echo "CreatgeRPCServer fail"
		exit 1
	fi
	StartRPCServer 
	while [ ${module_running} -eq 0 ]
	do
		sleep 1s
	done
}
MainProcess
