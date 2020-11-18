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
SRCS		+= ${SRCS_DIR}u_strlen.S

OBJS		 = ${SRCS:.S=.o}

AS			 = yasm
ASFLAGS		 = -felf64
ASFLAGS		+= -pgas

CC			 = cc

LD			:= ld
LDFLAGS		:= -melf_x86_64
LDFLAGS		+= --eh-frame-hdr
LDFLAGS		+= -dynamic-linker
LDFLAGS		+= /libexec/ld-elf.so.1
LDFLAGS		+= --hash-style=both
LDFLAGS		+= --enable-new-dtags 
LDPOST		:= /usr/lib/crt1.o
LDPOST		+= /usr/lib/crti.o
LDPOST		+= /usr/lib/crtbegin.o
LDPOST		+= -L/usr/lib
LDPOST		+= -lgcc
LDPOST		+= --as-needed
LDPOST		+= -lgcc_s
LDPOST		+= --no-as-needed
LDPOST		+= -lc
LDPOST		+= -lgcc
LDPOST		+= --as-needed
LDPOST		+= -lgcc_s
LDPOST		+= --no-as-needed
LDPOST		+= /usr/lib/crtend.o
LDPOST		+= /usr/lib/crtn.o

NAME		:= bsdsetsid

RM			:= rm -f

.SUFFIXES: .S .o

.S.o:
	${AS} ${ASFLAGS} -o ${.TARGET} ${.IMPSRC}

${NAME}: ${OBJS}
	${LD} ${LDFLAGS} -o ${.TARGET} ${.ALLSRC} ${LDPOST}
	# ${CC} -v -o ${.TARGET} ${.ALLSRC}

all: ${NAME}

clean:
	${RM} ${OBJS} ${NAME}

.PHONY: all clean
