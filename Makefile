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
# 2020-11-13 13:22
# Joe
#
# BSD Makefile

default: all

SRCS_DIR	:= src/
PREFIX		:= /usr/local/
DESTDIR		:=

SRCS		:= ${SRCS_DIR}c_bsdsetsid.S
SRCS		+= ${SRCS_DIR}e_err.S
SRCS		+= ${SRCS_DIR}u_print.S
SRCS		+= ${SRCS_DIR}u_strlen.S

OBJS		 = ${SRCS:.S=.o}

NAME		:= bsdsetsid

RM			:= rm -f

.SUFFIXES: .S .o

.S.o:
	${AS} -o ${.TARGET} ${.IMPSRC}

${NAME}: ${OBJS}
	${CC} -o ${.TARGET} ${.ALLSRC}

all: ${NAME}

clean:
	${RM} ${OBJS} ${NAME} vgcore*

.PHONY: all clean


# Files prefixes index
# --------------------
# c_  -> core program related
# u_  -> utils related
