#!/bin/bash

source /common.sh

cassandra_server_list=$(echo $CONFIGDB_SERVERS | sed 's/,/ /g')

cat > /etc/contrail/contrail-device-manager.conf << EOM
[DEFAULTS]
api_server_ip=$CONFIG_API_VIP
api_server_port=$CONFIG_API_PORT
log_file=${CONFIG_DEVICEMGR_LOG_FILE:-"$LOG_DIR/contrail-device-manager.log"}
log_level=${CONFIG_DEVICEMGR_LOG_LEVEL:-$LOG_LEVEL}
cassandra_server_list=$cassandra_server_list
zk_server_ip=$ZOOKEEPER_SERVERS
rabbit_server=$RABBITMQ_SERVERS
rabbit_vhost=$RABBITMQ_VHOST
rabbit_user=$RABBITMQ_USER
rabbit_password=$RABBITMQ_PASSWORD
redis_server=$REDIS_SERVER_IP
collectors=$COLLECTOR_SERVERS

$sandesh_client_config
EOM

set_third_party_auth_config
set_vnc_api_lib_ini

wait_for_contrail_api

exec "$@"
