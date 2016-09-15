#!/bin/bash

#Small go script to install in case that I need.

GO_VERSION="go1.7.1.linux-amd64.tar.gz"
cd /tmp/
wget https://storage.googleapis.com/golang/$GO_VERSION

tar xfvz $GO_VERSION
mv go /usr/local
rm /tmp/$GO_VERSION
cd /usr/local/bin/
ln -s /usr/local/go/bin/* .

go get github.com/Masterminds/glide
