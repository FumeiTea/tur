#!/bin/bash

dpkg-deb --build $1
mv $(basename $1).deb ../../../../pool/main/
