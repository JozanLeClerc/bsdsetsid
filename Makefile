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

OBJS		 = ${SRCS:.S=.o}

AS			:= yasm
ASFLAGS		:= -felf64
ASFLAGS		+= -pgas

LD			:= ld
LDFLAGS		:= -melf_x86_64

NAME		:= bsdsetsid

RM			:= rm -f

.SUFFIXES: .S .o

.S.o:
	${AS} ${ASFLAGS} -o ${.TARGET} ${.IMPSRC}

${NAME}: ${OBJS}
	${LD} ${LDFLAGS} -o ${.TARGET} ${.ALLSRC}

all: ${NAME}

clean:
	${RM} ${OBJS} ${NAME}

.PHONY: all clean
