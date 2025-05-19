#!/bin/bash

#Crea un grupo de seguridad para las máquinas del Backend con el nombre backend-sg.

aws ec2 create-security-group \
    --group-name backend-sg \
    --description "Reglas para los backend"

#Añada las siguientes reglas al grupo de seguridad:
#Acceso SSH (puerto 22/TCP) desde cualquier dirección IP.

aws ec2 authorize-security-group-ingress \
    --group-name backend-sg \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

#Acceso al puerto 3306/TCP desde cualquier dirección IP.
aws ec2 authorize-security-group-ingress \
    --group-name backend-sg \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0
