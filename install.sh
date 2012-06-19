#!/bin/bash
# Installation script.
# (C) Mark Blakeney, markb@berlios.de, May 2012.

PROG="gmail-indicator"
EXTNAM="$PROG.github.com"
BINDIR="$HOME/bin"
APPDIR="$HOME/.local/share/applications"
EXTDIR="$HOME/.local/share/gnome-shell/extensions"
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

# Work out if Desktop is Ubuntu or GNOME shell or other
if [ "${DESKTOP_SESSION#ubuntu}" != "$DESKTOP_SESSION" ]; then
    DESKTOP="ubuntu"
elif [ "${DESKTOP_SESSION#gnome-}" != "$DESKTOP_SESSION" ]; then
    DESKTOP="ubuntu"
elif [ "$DESKTOP_SESSION" = "gnome" ]; then
    DESKTOP="gnome"
else
    DESKTOP="other"
fi

gstool() {
    local act=$1
    local ext=$2

    if [ "$act" == "-d" ]; then
	Action="Disabling"
    else
	Action="Enabling"
    fi

    echo "$Action $EXTNAM shell extension"
    ./gsexttool $act "$EXTNAM"

    if [ $DESKTOP = "gnome" ]; then
	if [ -x /usr/bin/gnome-shell-extension-tool ]; then
	    /usr/bin/gnome-shell-extension-tool $act "$ext" &>/dev/null
	fi
	echo
	echo "*** If using GNOME shell then please restart your session ***"
	echo
    fi
}

UBUNTU_RESTART=0
if [ $REMOVE -eq 0 -a $LIST -eq 0 ]; then
    mkdir -p $BINDIR
    install -CDv $PROG -t $BINDIR
    mkdir -p $APPDIR
    cmp -s $PROG.desktop $APPDIR/$PROG.desktop &>/dev/null
    UBUNTU_RESTART=$((UBUNTU_RESTART|$?))
    install -CDv -m 644 $PROG.desktop -t $APPDIR

    mkdir -p $AUTDIR
    if [ ! -L $AUTDIR/$PROG.desktop ]; then
	echo "$APPDIR/$PROG.desktop -> $AUTDIR/$PROG.desktop"
	ln -sf $APPDIR/$PROG.desktop $AUTDIR/
    fi

    tmp=$(mktemp)
    echo "$APPDIR/$PROG.desktop" >$tmp
    mkdir -p $INDDIR
    cmp -s $tmp $INDDIR/$PROG &>/dev/null
    UBUNTU_RESTART=$((UBUNTU_RESTART|$?))
    install -CDv -m 644 $tmp -T $INDDIR/$PROG;
    rm -f $tmp

    if [ ! -f $HOME/.$PROG-rc ]; then
	install -Cv -m 600 $PROG-rc -T $HOME/.$PROG-rc
    fi

    mkdir -p $EXTDIR
    if ! diff -rq gnome-shell-extension $EXTDIR/$EXTNAM &>/dev/null; then
	rm -rf $EXTDIR/$EXTNAM
	echo "Installing $EXTDIR/$EXTNAM"
	cp -r gnome-shell-extension $EXTDIR/$EXTNAM
	gstool -e "$EXTNAM"
    fi
else
    if clean $BINDIR/$PROG; then
	rmdir --ignore-fail-on-non-empty $BINDIR
    fi
    clean $APPDIR/$PROG.desktop
    clean $AUTDIR/$PROG.desktop
    clean $INDDIR/$PROG
    UBUNTU_RESTART=$((UBUNTU_RESTART|(!$?)))

    if clean $EXTDIR/$EXTNAM; then
	gstool -d "$EXTNAM"
    fi
fi

if [ $UBUNTU_RESTART -ne 0 -a $DESKTOP = "ubuntu" ]; then
    echo
    echo "*** Please restart your Ubuntu session ***"
    echo
fi

exit 0
