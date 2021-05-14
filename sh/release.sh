#!/bin/bash

# release leanote

# 当前路径
SCRIPT_PATH=$(cd "$(dirname "$0")" || exit; pwd)
echo "$SCRIPT_PATH"

# 代码路径
SOURCE_PATH="$SCRIPT_PATH/../"
echo "$SOURCE_PATH"

# tmp path to store leanote release files
tmp="$SCRIPT_PATH/release_tmp"
echo "$tmp"

# version
V="v2.6.1"

##=================================
# 1. 先build 成 3个平台, 2种bit = 6种
##=================================

# cd /Documents/Go/package2/src/github.com/leanote/leanote/bin
# GOOS=darwin GOARCH=amd64 go build -o leanote-darwin-amd64 ../app/tmp

cd "$SOURCE_PATH" || exit

# $1 = darwin, linux
# $2 = amd64
build()
{
  echo "build-$1-$2"

  GOOS=$1 GOARCH=$2 revel build --run-mode=prod -a . -t "$tmp/$1-$2" # build
}

#build "linux" "386";
build "linux" "amd64";
#build "linux" "arm";

#build "windows" "386";
#build "windows" "amd64";

#build "darwin" "amd64";

##===========
# 2. 打包
##===========

# 创建一个$V的目录存放之
rm -rf "$SCRIPT_PATH/$V"
mkdir "$SCRIPT_PATH/$V"

cd "$SCRIPT_PATH" || exit

# $1 = linux
# $2 = 386, amd64
tarRelease()
{
  echo "tar-$1-$2"

  mkdir -p "$tmp"/leanote/bin

  # move source
  mv "$tmp/$1-$2"/src/github.com/leanote/leanote/* "$tmp"/leanote

  # move bin
  mv "$tmp/$1-$2"/* "$tmp"/leanote/bin

  rm -rf "$tmp"/leanote/bin/src/github.com/leanote

  # fix run.sh
  sed -i '/pwd)/r '<(cat<<'EOF'

# set link
link_path="$SCRIPTPATH/src/github.com/leanote"
if [ ! -d "$link_path" ]; then
  mkdir -p "$link_path"
fi
rm -rf "$link_path"/leanote # Delete first
ln -s ../../../../ "$link_path"/leanote

EOF
) "$tmp"/leanote/bin/run.sh

  # move docker env
  cp -rT "$SCRIPT_PATH"/docker-compose "$tmp"/leanote

  # package
  tar -cf "$SCRIPT_PATH/$V/leanote-$1-$2-$V.bin.tar" -C "$tmp" leanote
  gzip "$SCRIPT_PATH/$V/leanote-$1-$2-$V.bin.tar"

  # remove temp files
  rm -rf "$tmp"/leanote
  rm -rf "$tmp/$1-$2"
}

#tarRelease "linux" "386";
tarRelease "linux" "amd64";
#tarRelease "linux" "arm";

#tarRelease "windows" "386";
#tarRelease "windows" "amd64";

#tarRelease "darwin" "amd64";

# remove tmp dir
rm -rf "$tmp"
