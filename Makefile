#!/usr/bin/make -f
# -*- makefile -*-
#
# Copyright (C) 2006-2009 BATMAN contributors
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of version 2 of the GNU General Public
# License as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA
#

ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
	Q_CC = @echo '   ' CC $@;
	Q_LD = @echo '   ' LD $@;
	export Q_CC
	export Q_LD
endif
endif

CC ?=		gcc
CFLAGS +=	-pedantic -Wall -W -std=gnu99
EXTRA_CFLAGS =	-DDEBUG_MALLOC -DMEMORY_USAGE -DREVISION_VERSION=$(REVISION_VERSION)
LDFLAGS +=	-lpthread

SBINDIR =	$(INSTALL_PREFIX)/usr/sbin

OBJ = allocate.o hash.o list-batman.o vis.o udp_server.o
DEP = $(OBJ:.o=.d)

BINARY_NAME= vis

REVISION= $(shell      if [ -d .git ]; then \
                               echo $$(git describe --always --dirty 2> /dev/null || echo "[unknown]"); \
                        fi)
REVISION_VERSION=\"\ $(REVISION)\"

all: $(BINARY_NAME)

$(BINARY_NAME): $(OBJ) Makefile
	$(Q_LD)$(CC) -o $@ $(OBJ) $(LDFLAGS)

.c.o:
	$(Q_CC)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) -MD -c $< -o $@
-include $(DEP)

clean:
	rm -f $(BINARY_NAME) $(OBJ) $(DEP)

install: $(BINARY_NAME)
	mkdir -p $(SBINDIR)
	install -m 0755 $(BINARY_NAME) $(SBINDIR)

.PHONY: all clean install
