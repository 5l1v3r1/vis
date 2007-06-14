/*
 * vis.c
 *
 * Copyright (C) 2006 Andreas Langer <a.langer@q-dsl.de>:
 *
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of version 2 of the GNU General Public
 * License as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA
 *
 */



#include "list-batman.h"



#define MAXCHAR 4096
#define VIS_PORT 1968
#define DOT_DRAW_PORT 2004
#define ADDR_STR_LEN 16
#define PACKET_FIELD_LENGTH 5
#define VERSION "0.1 alpha"



extern struct list_head_first udp_if_list;
extern pthread_t udp_server_thread;
extern pthread_t master_thread;



struct thread_data {
	int socket;
	char ip[ADDR_STR_LEN];
};

struct neighbour {
	struct node *node;
	unsigned char packet_count;
	struct neighbour *next;
};

struct node {
	unsigned int addr;
	unsigned char packet_count_average;
	unsigned char last_seen;
	unsigned char gw_class;
	struct neighbour *neighbour;
	struct neighbour *is_neighbour;
	pthread_mutex_t mutex;
};

typedef struct _buffer {
	char *buffer;
	int counter;
	struct _buffer *next;
	pthread_mutex_t mutex;
} buffer_t;

struct udp_if {
	struct list_head list;
	char *dev;
	int32_t sock;
	struct sockaddr_in addr;
};


void clean_hash();
void clean_buffer();
