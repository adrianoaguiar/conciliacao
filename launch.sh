#!bin/bash

sudo docker build -t chip . && docker run -p 4567:4567 -ti chip bash
