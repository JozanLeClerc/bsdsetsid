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
# 2020-11-21 14:36
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
SRCS		+= e_err
SRCS		+= u_hexdec
SRCS		+= u_print
SRCS		+= u_strlen
SRCS		+= u_strncmp
SRCS		:= ${SRCS:S/$/.S/g}
SRCS		:= ${SRCS:S/^/${SRCS_DIR}/g}

OBJS		:= ${SRCS:=.o}

NAME		:= bsdsetsid

RM			:= rm -f
RMDIR		:= rmdir -p
MKDIR		:= mkdir -p

.OBJDIR: ./
.SUFFIXES: .S.o .o
.S.S.o:
	${AS} -o ${.TARGET:S/src/obj/} ${.IMPSRC}

${OBJS_DIR}:
	${MKDIR} ${OBJS_DIR}

${NAME}: ${OBJS}
	${CC} -o ${.TARGET} ${.ALLSRC:S/src/obj/}

all: ${OBJS_DIR} ${NAME}

clean:
	${RM} ${OBJS:S/src/obj/} ${NAME} vgcore*
	${RM} -R obj

.PHONY: all clean


# Files prefixes index
# --------------------
# c_  -> core program related
# u_  -> utils related
