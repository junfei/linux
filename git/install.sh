#!/bin/bash

function end() {
	if [ $? -eq 1 ];then
		exit 0
	fi
}

function first() {
	if [ -f `which yum` ];then
	    yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel wget unzip
	elif [ -f `which apt-get` ];then 
	    apt-get install libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev wget unzip
	else
		echo "Sorry,this script only working on Ubuntu or Centos ..."
	fi

}

function install() {
    first
	cd ~/
	wget https://github.com/git/git/archive/master.zip  
	if [ $? -eq 0 ];then 
	    unzip -q master.zip
	    cd git-master
	    make prefix=/usr/local all
        make prefix=/usr/local install
		
	    cd contrib/completion/
	    MYSHELL=`echo $SHELL |awk -F/ '{print $NF}'`
	    cp git-completion.$MYSHELL ~/.git-completion.$MYSHELL
	    echo "Please enter your real username and password for github to ~/.netrc "
	    echo "machine github.com login your-username password your-passwork" >> ~/.netrc

	    cd ~/
	    rm -fr git-master
        else
	    echo "Sorry,the file is not download OK !"
	    exit 0
	fi

}

function update() {
    [ -d ~/git ] || git clone https://github.com/git/git ~/git
    cd ~/git
    git pull
    make prefix=/usr/local all
    make prefix=/usr/local install
    make clean
}

echo "Please enter the num.
      1.Install git  2.Update git ..."
read NUM 

if [ $NUM -eq 1 ];then
	install
fi
if [ $NUM -eq 2 ];then
	update
fi

#use git
echo "show the git version"
git --version


