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

# vis build
BINARY_NAME= vis
OBJ = allocate.o hash.o list-batman.o vis.o udp_server.o

# vis flags and options
CFLAGS +=	-pedantic -Wall -W -std=gnu99 -MD
CPPFLAGS +=	-DDEBUG_MALLOC -DMEMORY_USAGE -DREVISION_VERSION=$(REVISION_VERSION)
LDLIBS +=	-lpthread

# disable verbose output
ifneq ($(findstring $(MAKEFLAGS),s),s)
ifndef V
	Q_CC = @echo '   ' CC $@;
	Q_LD = @echo '   ' LD $@;
	export Q_CC
	export Q_LD
endif
endif

# standard build tools
CC ?=		gcc
RM ?= rm -f
INSTALL ?= install
MKDIR ?= mkdir -p
COMPILE.c = $(Q_CC)$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c
LINK.o = $(Q_LD)$(CC) $(LDFLAGS) $(TARGET_ARCH)

# standard install paths
SBINDIR =	$(INSTALL_PREFIX)/usr/sbin

# try to generate revision
REVISION = $(shell if [ -d .git ]; then echo $$(git describe --always --dirty 2> /dev/null || echo "[unknown]"); fi)
REVISION_VERSION=\"\ $(REVISION)\"

# default target
all: $(BINARY_NAME)

# standard build rules
.SUFFIXES: .o .c
.c.o:
	$(COMPILE.c) -o $@ $<

$(BINARY_NAME): $(OBJ)
	$(LINK.o) $^ $(LDLIBS) -o $@

clean:
	$(RM) $(BINARY_NAME) $(OBJ) $(DEP)

install: $(BINARY_NAME)
	$(MKDIR) $(SBINDIR)
	$(INSTALL) -m 0755 $(BINARY_NAME) $(SBINDIR)

# load dependencies
DEP = $(OBJ:.o=.d)
-include $(DEP)

.PHONY: all clean install
