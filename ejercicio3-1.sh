#Crear un script para crear la infraestructura de la práctica propuesta por el profesor.

#!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
# Referencia: https://docs.aws.amazon.com/es_es/cli/latest/userguide/cliv2-migration.html#cliv2-#migration-output-pager
export AWS_PAGER=""


#grupo de seguridad para el balanceador
aws ec2 create-security-group \
    --group-name lb-sg \
    --description "Reglas para el balanceador"

#reglas para el balanceador
aws ec2 authorize-security-group-ingress \
    --group-name lb-sg \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name lb-sg \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0


#grupo de seguridad para fronted

aws ec2 create-security-group \
    --group-name frontend-sg \
    --description "Reglas para el front-end"

#reglas para el fronted

aws ec2 authorize-security-group-ingress \
    --group-name frontend-sg \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name frontend-sg \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0  


#grupo de seguridad para nfs

aws ec2 create-security-group \
    --group-name nfs-sg \
    --description "Reglas para el servidor NFS"

# Reglas para acceso NFS
aws ec2 authorize-security-group-ingress \
    --group-name nfs-sg \
    --protocol tcp \
    --port 2049 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name nfs-sg \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0 

#grupo de seguridad para backend

aws ec2 create-security-group \
    --group-name back-sg \
    --description "Reglas para la base de datos MySQL"

#reglas para backend

aws ec2 authorize-security-group-ingress \
    --group-name back-sg \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0


aws ec2 authorize-security-group-ingress \
    --group-name back-sg \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0 

# 2.lanzar instancias
# lanzar balanceador
aws ec2 run-instances \
    --image-id ami-03bff4aeb4895d95c \
    --instance-type t3.small \
    --count 1 \
    --key-name vockey \
    --security-groups lb-sg \
    --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":30,"VolumeType":"gp2","DeleteOnTermination":true}}]' \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=loadbalancer}]'

# lanzar frontend1
aws ec2 run-instances \
    --image-id ami-03bff4aeb4895d95c \
    --instance-type t3.small \
    --count 1 \
    --key-name vockey \
    --security-groups frontend-sg \
    --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":30,"VolumeType":"gp2","DeleteOnTermination":true}}]' \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=frontend-1}]'

# lanzar frontend2
aws ec2 run-instances \
    --image-id ami-03bff4aeb4895d95c \
    --instance-type t3.small \
    --count 1 \
    --key-name vockey \
    --security-groups frontend-sg \
    --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":30,"VolumeType":"gp2","DeleteOnTermination":true}}]' \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=frontend-2}]'

# lanzar nfs
aws ec2 run-instances \
    --image-id ami-03bff4aeb4895d95c \
    --instance-type t3.small \
    --count 1 \
    --key-name vockey \
    --security-groups nfs-sg \
    --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":30,"VolumeType":"gp2","DeleteOnTermination":true}}]' \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=nfs-server}]'

# lanzar backend
aws ec2 run-instances \
    --image-id ami-03bff4aeb4895d95c \
    --instance-type t3.small \
    --count 1 \
    --key-name vockey \
    --security-groups back-sg \
    --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":30,"VolumeType":"gp2","DeleteOnTermination":true}}]' \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=backend}]'
