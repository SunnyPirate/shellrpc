#!/bin/bash
RPC_LOG_FILE="./rpc.log"
RPC_CONTROL_REQUEST=01
RPC_SERVICE_REQUEST=02
RPC_SERVICE_RESPONSE=03
RPC_DEFAULT_CLIENT_THREAD=1

RPC_PORT_FREE=0
RPC_PORT_LISTEN=1
RPC_SUCCESS=0
RPC_FAIL=1
RPC_TRUE=0
RPC_FALSE=1
RPC_MESSAGE_MAGIC_NUM=022981
RPC_META_SIZE_HEX_WIDTH=4
RPC_DATA_SIZE_HEX_WIDTH=8
RPC_PROTO_HEADER_META_LEN=10
RPC_PROCESS_SERVER_MODE=0
RPC_PROCESS_CLIENT_MODE=1

RPC_PROCESSOR_FLOW_CONTINUE=0
RPC_PROCESSOR_FLOW_STOP=1

RPC_CONTROL_STOP_COMMAND=RPCControlStopServer
RPC_CONTROL_ROLE_SERVER=Server
RPC_CONTROL_ROLE_CLIENT=Client

