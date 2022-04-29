
# Table of Contents

1.  [Dependencies](#orgfb13261)
2.  [Installation](#org4f42ed6)
3.  [Usage](#orgcad236a)

Simple implementation of util-linux **setsid** for FreeBSD. This was not tested
on other BSD's or macOS but this probably works just fine.


<a id="orgfb13261"></a>

# Dependencies

-   A C compiler
-   BSD Make


<a id="org4f42ed6"></a>

# Installation

You can get **bsdsetsid** either through `git` or `fossil`.

For `fossil` use:

```sh
mkdir bsdsetsid
cd bsdsetsid
fossil clone \
	https://chiselapp.com/user/JozanLeClerc/repository/bsdsetsid \
	bsdsetsid.fossil
fossil open --force bsdsetsid.fossil
```

or for `git`:

```sh
git clone git://gitjoe.xyz/jozan/bsdsetsid.git
cd bsdsetsid
```

Then build and install the program:

```sh
make
sudo make install clean
```

Note that if you are one macOS, you need to install and use BSD Make instead
of GNU Make.


<a id="orgcad236a"></a>

# Usage

Example of usage:

```sh
bsdsetsid st -e sh -c 'cowsay hello; zsh -i'
exit
```

Replace `st` and its arguments with any program you'd like to run detached
from the current shell.

For more informations, run:

```sh
man bsdsetsid
```

Thanks for checking **bsdsetsid**.

