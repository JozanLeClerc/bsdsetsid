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

SRCS_DIR	:= src/
OBJS_DIR	:= obj/
PREFIX		?= /usr/local/
DESTDIR		:=
MAKEOBJDIR	:= ./

SRCS		 = c_bsdsetsid
SRCS		:= ${SRCS:S/$/.c/g}
SRCS		:= ${SRCS:S/^/${SRCS_DIR}/g}

OBJS		:= ${SRCS:=.o}

INCS		:= ${SRCS:.c=.h}

NAME		:= bsdsetsid

CFLAGS		 = -std=c89
CFLAGS		+= -Wall
CFLAGS		+= -Wextra
CFLAGS		+= -Werror
CFLAGS		+= -pedantic

RM			:= rm -f
RMDIR		:= rmdir -p
MKDIR		:= mkdir -p

.OBJDIR: ./
.SUFFIXES: .c.o .c
.c.c.o: ${INCS}
	${CC} -c ${CFLAGS} -o ${.TARGET:S/src/obj/} ${.IMPSRC}

${OBJS_DIR}:
	${MKDIR} ${OBJS_DIR}

${NAME}: ${OBJS}
	${CC} ${CFLAGS} -o ${.TARGET} ${.ALLSRC:S/src/obj/}

all: ${OBJS_DIR} ${NAME}

clean:
	${RM} ${OBJS:S/src/obj/} ${NAME} vgcore*
	${RM} -R obj

.PHONY: all clean


# Files prefixes index
# --------------------
# c_  -> core program related
