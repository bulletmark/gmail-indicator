#!/bin/bash
# Installation script.
# (C) Mark Blakeney, markb@berlios.de, May 2012.

PROG="gmail-indicator"
BINDIR="$HOME/bin"
APPDIR="$HOME/.local/share/applications"
AUTDIR="$HOME/.config/autostart"
INDDIR="$HOME/.config/indicators/messages/applications"

usage() {
    echo "Usage: $(basename $0) [-options]"
    echo "Options:"
    echo "-r <remove/uninstall>"
    echo "-l <list only>"
    exit 1
}

REMOVE=0
LIST=0
while getopts rl c; do
    case $c in
    r) REMOVE=1;;
    l) LIST=1;;
    ?) usage;;
    esac
done

shift $((OPTIND - 1))

if [ $# -ne 0 ]; then
    usage
fi

if [ "$(id -un)" = "root" ]; then
    echo "Don't install/uninstall as root/sudo. Just run as your own user."
    exit 1
fi

# Delete or list file/dir
clean() {
    local tgt=$1

    if [ -e $tgt -o -h $tgt ]; then
	if [ -d $tgt ]; then
	    if [ $REMOVE -eq 1 ]; then
		echo "Removing $tgt/"
		rm -rf $tgt
		return 0
	    else
		ls -ld $tgt/
	    fi
	elif [ $REMOVE -ne 0 ]; then
	    echo "Removing $tgt"
	    rm -r $tgt
	    return 0
	else
	    ls -l $tgt
	fi
    fi

    return 1
}

if [ $REMOVE -eq 0 -a $LIST -eq 0 ]; then
    mkdir -p $BINDIR
    install -CDv $PROG -t $BINDIR
    mkdir -p $APPDIR
    install -CDv -m 644 $PROG.desktop -t $APPDIR

    mkdir -p $AUTDIR
    if [ ! -L $AUTDIR/$PROG.desktop ]; then
	echo "$APPDIR/$PROG.desktop -> $AUTDIR/$PROG.desktop"
	ln -sf $APPDIR/$PROG.desktop $AUTDIR/
    fi

    tmp=$(mktemp)
    echo "$APPDIR/$PROG.desktop" >$tmp
    mkdir -p $INDDIR
    install -CDv -m 644 $tmp -T $INDDIR/$PROG;
    rm -f $tmp

    if [ ! -f $HOME/.$PROG-rc ]; then
	install -Cv -m 600 $PROG-rc -T $HOME/.$PROG-rc
    fi
else
    if clean $BINDIR/$PROG; then
	rmdir --ignore-fail-on-non-empty $BINDIR
    fi
    clean $APPDIR/$PROG.desktop
    clean $AUTDIR/$PROG.desktop
    clean $INDDIR/$PROG
fi

exit 0
