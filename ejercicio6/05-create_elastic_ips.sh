#!/bin/bash
set -x  # Modo depuración para ver los comandos ejecutados

# Deshabilitar la paginación de salida de AWS CLI
export AWS_PAGER=""

# Importamos las variables de configuración
source .env

# Asignar IP elástica al balanceador (LB)
BALANCEADOR_ID=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_LB" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)

# Creamos una IP elástica
ELASTIC_IP_LB=$(aws ec2 allocate-address --query PublicIp --output text)

# Asociamos la IP elástica al balanceador de carga
aws ec2 associate-address --instance-id $BALANCEADOR_ID --public-ip $ELASTIC_IP_LB
echo "IP elástica $ELASTIC_IP_LB asociada al balanceador de carga ($INSTANCE_NAME_LB)."

# Asignar IP elástica a frontend 1
FRONTEND1_ID=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_FRONTEND-1" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)

# Creamos una IP elástica
ELASTIC_IP_FRONTEND1=$(aws ec2 allocate-address --query PublicIp --output text)

# Asociamos la IP elástica al frontend 1
aws ec2 associate-address --instance-id $FRONTEND1_ID --public-ip $ELASTIC_IP_FRONTEND1
echo "IP elástica $ELASTIC_IP_FRONTEND1 asociada a $INSTANCE_NAME_FRONTEND-1."

# Asignar IP elástica a frontend 2
FRONTEND2_ID=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_FRONTEND-2" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)

# Creamos una IP elástica
ELASTIC_IP_FRONTEND2=$(aws ec2 allocate-address --query PublicIp --output text)

# Asociamos la IP elástica al frontend 2
aws ec2 associate-address --instance-id $FRONTEND2_ID --public-ip $ELASTIC_IP_FRONTEND2
echo "IP elástica $ELASTIC_IP_FRONTEND2 asociada a $INSTANCE_NAME_FRONTEND-2."

# Asignar IP elástica a servidor NFS
NFS_ID=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_NFS" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)

# Creamos una IP elástica
ELASTIC_IP_NFS=$(aws ec2 allocate-address --query PublicIp --output text)

# Asociamos la IP elástica al servidor NFS
aws ec2 associate-address --instance-id $NFS_ID --public-ip $ELASTIC_IP_NFS
echo "IP elástica $ELASTIC_IP_NFS asociada a $INSTANCE_NAME_NFS."

# Asignar IP elástica a servidor backend (MySQL)
BACKEND_ID=$(aws ec2 describe-instances \
            --filters "Name=tag:Name,Values=$INSTANCE_NAME_BACKEND" \
                      "Name=instance-state-name,Values=running" \
            --query "Reservations[*].Instances[*].InstanceId" \
            --output text)

# Creamos una IP elástica
ELASTIC_IP_BACKEND=$(aws ec2 allocate-address --query PublicIp --output text)

# Asociamos la IP elástica al servidor backend (MySQL)
aws ec2 associate-address --instance-id $BACKEND_ID --public-ip $ELASTIC_IP_BACKEND
echo "IP elástica $ELASTIC_IP_BACKEND asociada a $INSTANCE_NAME_BACKEND."
