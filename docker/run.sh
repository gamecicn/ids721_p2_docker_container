#!/bin/bash


TARGET="chardrawer"
VERSION="1.0.0"

USAGE="

USAGE: $(basename "$0") start|START port 8010  8011 ... 
       $(basename "$0") build|BUILD
       $(basename "$0") stop|STOP
where:
	start|START    start component, followd by ports  
	build|BUILD    build component
	stop|STOP      stop component
"


build_image(){

    if [  -d "./requirements.txt" ];then
	rm ./requirements.txt
    fi

    if [  -d "./scripts" ];then
       rm -r ./scripts
    fi
 
    cp ../requirements.txt . 
    cp -rf ../scripts . 

    sudo docker build . -t "$TARGET":"$VERSION"

    rm -rf ./scripts
}


for i in "$@" 
do
	key="$1"
	case $key in
		build|BUILD )
		shift
		op="build"
		;;
		start|START )
		shift
		op="start"
		#shift
		PORT=$@
		break
		;;
		stop|STOP )
		shift
		op="stop"
		;;
		load|LOAD )
		shift
		op="load"
		;;
		save|SAVE )
		shift
		op="save"
		;;
		push|PUSH )
		shift
		op="push"
		;;
		pull|PULL )
		shift
		op="pull"
		;;
		-h|--help )
		echo "$USAGE"
		exit
		;;
		* )
		echo "$USAGE"
		exit 1
	esac
done


IMAGES_ID=$(sudo docker images | grep "$TARGET" | grep "$VERSION" |  awk '{print $3}')

if [[ $op == "build" ]]; then
	echo "*** BUILD IMAGE "
	build_image 
elif [[ $op == "start" ]]; then
	sudo docker run -v $PWD:/tmp chardrawer:1.0.0 python draw.py /tmp/duke.png
elif [[ $op == "stop" ]]; then
	echo "*** STOPING "
	container=$(sudo docker ps | grep "$ALI_REPO":"$VERSION" | cut -d " " -f1)
	sudo docker stop $container
	sudo docker rm $container
else
	echo "Unknow argument...."
fi



exit 0

 














