#!/bin/bash


TARGET="market_rabbit"
VERSION="1.2.0"
ALI_REPO="registry.cn-beijing.aliyuncs.com/medo_registry/rabbit_market"

USAGE="

USAGE: $(basename "$0") start|START port 8010  8011 ... 
       $(basename "$0") build|BUILD
       $(basename "$0") stop|STOP
       $(basename "$0") load|LOAD
       $(basename "$0") save|SAVE
	   $(basename "$0") push|PUSH
	   $(basename "$0") pull|PULL
where:
	start|START    start component, followd by ports  
	build|BUILD    build component
	stop|STOP      stop component
	load|LOAD      load image to local repository
	save|SAVE      save component to image
	push|PUSH	   push image to ali repository
	pull|PULL	   push image from ali repository
"


build_image(){

    if [  -d "./requirements.txt" ];then
	rm ./requirements.txt
	fi

	if [  -d "./server" ];then
	rm -r ./server
	fi
	 
	cp ../requirements.txt . 
	cp -rf ../server . 
	
	sudo docker build . -t "$TARGET":"$VERSION"
	
	rm -rf ./server
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
	echo "*** STARTING "
	for var in $PORT
	do
		sudo docker run -d -p "$var":80 \
		--mount source=sshvolume,target=/ser_share/home\
		--env RIP=$(ifconfig eth0 | grep -w "inet" | sed 's/addr:/ /g'  | awk '{print $2}') \
		--env RPORT="$var" \
		-t "$ALI_REPO":"$VERSION"
	done
elif [[ $op == "load" ]]; then
	echo "*** LOADING "
	sudo docker load -i "$TARGET"_"$VERSION".tar.gz
elif [[ $op == "push" ]]; then
	echo "*** PUSHING "
	sudo docker login --username=gameci registry.cn-beijing.aliyuncs.com
	sudo docker tag $IMAGES_ID "$ALI_REPO:$VERSION"
	sudo docker push "$ALI_REPO:$VERSION"
elif [[ $op == "pull" ]]; then
	echo "*** PULLING "
	sudo docker login --username=gameci registry.cn-beijing.aliyuncs.com
	sudo docker pull "$ALI_REPO:$VERSION"
elif [[ $op == "stop" ]]; then
	echo "*** STOPING "
	container=$(sudo docker ps | grep "$ALI_REPO":"$VERSION" | cut -d " " -f1)
	sudo docker stop $container
	sudo docker rm $container
elif [[ $op == "save" ]]; then
	echo "*** SAVING IMAGE"
	sudo docker save "$TARGET":"$VERSION" | gzip -c  > "$TARGET"_"$VERSION".tar.gz
else
	echo "Unknow argument...."
fi



exit 0

 














