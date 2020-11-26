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
# Wed Nov 25 22:16:00 CET 2020
# Joe
#
# BSD Makefile

default: all

SRCS_DIR	:= src
# OBJS_DIR	:= obj
PREFIX		?= /usr/local/
DESTDIR		:=
MAKEOBJDIR	:= ./

SRCS		:= c_bsdsetsid
SRCS		+= c_fork
SRCS		:= ${SRCS:S/$/.c/g}
SRCS		:= ${SRCS:S/^/${SRCS_DIR}\//g}

OBJS		:= ${SRCS:=.o}
# OBJS		:= ${OBJS:S/${SRCS_DIR}/${OBJS_DIR}/g}

INCS		:= ${SRCS:.c=.h}

NAME		:= bsdsetsid

CC			:= cc
CFLAGS		:= -std=c89
CFLAGS		+= -Wall
CFLAGS		+= -Wextra
CFLAGS		+= -Werror
CFLAGS		+= -pedantic

RM			:= rm -f
MKDIR		:= mkdir -p
SED			:= sed -i ''

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

.PHONY: all clean depend

# Files prefixes index
# --------------------
# c_  -> core program related
