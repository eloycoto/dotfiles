#!/bin/bash

#Small go script to install in case that I need.

GO_VERSION="go1.8.3.linux-amd64.tar.gz"
cd /tmp/
wget https://storage.googleapis.com/golang/$GO_VERSION

tar xfvz $GO_VERSION
mv go /usr/local
rm /tmp/$GO_VERSION
cd /usr/local/bin/
ln -s /usr/local/go/bin/* .

export GOPATH=$HOME/.go/
export GOROOT=/usr/local/go/

go get github.com/Masterminds/glide
go get github.com/LK4D4/vndr
go get -u github.com/jteeuwen/go-bindata/...
