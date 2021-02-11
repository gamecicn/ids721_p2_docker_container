FROM python:3.6-buster

WORKDIR /usr/src/app

COPY ./requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/

COPY  ./scripts/draw.py   ./

RUN chmod 755 ./draw.py

 
WORKDIR /usr/src/app


CMD [ "python", "./draw.py"]































