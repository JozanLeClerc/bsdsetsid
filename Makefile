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
SRCS		+= ${SRCS_DIR}u_write.S

OBJS		 = ${SRCS:.S=.o}

ASM			?= yasm
ASMFLAGS	:= -felf64
ASMFLAGS	+= -pgas

LD			:= ld.lld
LDFLAGS		:=

NAME		:= bsdsetsid

RM			:= rm -f

.SUFFIXES: .S .o

.S.o:
	${ASM} ${ASMFLAGS} -o ${.TARGET} ${.IMPSRC}

${NAME}: ${OBJS}
	${LD} -o ${.TARGET} ${.ALLSRC}

all: ${NAME}

clean:
	${RM} ${OBJS} ${NAME}

.PHONY: all clean
