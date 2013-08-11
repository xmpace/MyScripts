#!/bin/bash

#####################################
# 这个脚本用来将一个文件夹中的文本文件（包括代码和文本数据）拷贝到另一个文件夹中
# 并保持原文件夹的目录树结构
#####################################

printUSAGE() {
    echo "USAGE: `/usr/bin/basename $0` $@." >&2
    exit 1
}

printERROR() {
    echo "ERROR: `/usr/bin/basename $0` $@." >&2
    exit 1
}

if [ $# -lt 2 ] ; then
    printUSAGE "[src] [dest]"
fi

if [ ! -d "$1" ] ; then
    printERROR "The source $1 is not a direcotry, or does not exist"
fi

if [ ! -d "$2" ] ; then
    printERROR "The dest $2 is not a directory, or does not exist"
fi

SRCDIR="`(cd $1 ; pwd ; )`"
DESTDIR="`(cd $2 ; pwd ; )`"

OLDIFS="$IFS"
IFS=$(echo -en "\n\b")
for dir in `find $SRCDIR -type d` ; do
    for file in `find $dir -maxdepth 1 -type f` ; do
	case "`file $file`" in
	    *ASCII*)
		filepath=`dirname $file | sed s@$SRCDIR@@`
		filename=`basename $file`
		mkdir -p $DESTDIR$filepath 2> /dev/null
		cp -i $file $DESTDIR$filepath
		;;
	    *)
		;;
	esac
    done
done	
IFS="$OLDIFS"