#pragma once

#define NET_ANY_IP_STRING "0.0.0.0"
#define NET_ANY_IP 0
#define NET_KEEP_ALIVE_TIME 5.0f
#define NET_INVALID_SOCKET -1

#define OCT_DEFAULT_PORT 5151
#define OCT_BROADCAST_PORT 15151
#define OCT_RECV_BUFFER_SIZE 1024
#define OCT_SEND_BUFFER_SIZE 1024
#define OCT_MAX_MSG_BODY_SIZE 500
#define OCT_SEQ_NUM_SIZE sizeof(uint16_t)
#define OCT_PACKET_HEADER_SIZE (OCT_SEQ_NUM_SIZE + sizeof(bool))
#define OCT_MAX_MSG_SIZE (OCT_PACKET_HEADER_SIZE + OCT_MAX_MSG_BODY_SIZE)
#define OCT_PING_INTERVAL 1.0f
#define OCT_BROADCAST_INTERVAL 5.0f
