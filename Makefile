# ========================
# =====    ===============
# ======  ================
# ======  ================
# ======  ====   ====   ==
# ======  ===     ==  =  =
# ======  ===  =  ==     =
# =  ===  ===  =  ==  ====
# =  ===  ===  =  ==  =  =
# ==     =====   ====   ==
# ========================
#
# bsdsetsid: Makefile
# Sun Nov 29 18:27:43 CET 2020
# Joe
#
# BSD Makefile

default: all

SRCS_DIR	:= src
MAN_DIR		:= man
# OBJS_DIR	:= obj
PREFIX		?= /usr/local
DESTDIR		:=
MAKEOBJDIR	:= ./

SRCS		:= c_bsdsetsid
SRCS		+= c_fork
SRCS		+= c_args
SRCS		:= ${SRCS:S/$/.c/g}
SRCS		:= ${SRCS:S/^/${SRCS_DIR}\//g}

OBJS		:= ${SRCS:=.o}
# OBJS		:= ${OBJS:S/${SRCS_DIR}/${OBJS_DIR}/g}

INCS		:= ${SRCS:.c=.h}

NAME		:= bsdsetsid

CC			?= cc
CFLAGS		:= -std=c89
CFLAGS		+= -Wall
CFLAGS		+= -Wextra
CFLAGS		+= -Werror
CFLAGS		+= -pedantic
CFLAGS		+= -march=native -O2 -pipe

RM			:= rm -f
MKDIR		:= mkdir -p
SED			:= sed -i ''
GZIP		:= gzip
GUNZIP		:= gunzip
INSTALL		:= install

.OBJDIR: ./
.SUFFIXES: .c.o .o

.c.c.o: ${INCS}
	${CC} -c ${CFLAGS} -o ${.TARGET} ${.IMPSRC}

${NAME}: ${OBJS}
	${CC} ${CFLAGS} -o ${.TARGET} ${.ALLSRC}

# ${OBJS_DIR}:
	# ${MKDIR} ${OBJS_DIR}

all: ${OBJS_DIR} ${NAME}

clean:
	${RM} ${OBJS} ${NAME} vgcore*
	# ${RM} -R ${OBJS_DIR}

install: ${NAME}
	${GZIP} ${MAN_DIR}/${NAME}.1
	${MKDIR} ${PREFIX}/man/man1
	${INSTALL} -m0444 ${MAN_DIR}/${NAME}.1.gz ${PREFIX}/man/man1/${NAME}.1.gz
	${GUNZIP} ${MAN_DIR}/${NAME}.1.gz
	${MKDIR} ${PREFIX}/bin
	${INSTALL} -m0555 ${NAME} ${PREFIX}/bin/${NAME}

uninstall:
	${RM} ${PREFIX}/man/man1/${NAME}.1.gz
	${RM} ${PREFIX}/bin/${NAME}

.PHONY: all clean install

# Files prefixes index
# --------------------
# c_  -> core program related
