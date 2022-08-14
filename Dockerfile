FROM python:3.8-slim-buster
EXPOSE 8000
RUN python3 -m pip install --upgrade pip
WORKDIR /srv
ADD . /srv/
RUN python3 -m pip install -r /srv/requirements.txt

CMD [ "python3", "-m" ,"uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000",  "--backlog", "8", "--timeout-keep-alive", "300", "--no-server-header", "--header", "server:TTServer", "--reload"]