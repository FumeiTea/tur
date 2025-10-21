#!/bin/bash


UserId=u0_a365
IP=192.168.82.241
Host=8022
Dir=/data/data/com.termux/files/home/

scpp(){
  scp -P ${Host} $1  ${UserId}@${IP}:${Dir}/$2
}

