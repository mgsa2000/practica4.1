#!/bin/bash
set -x  # Modo depuración para ver los comandos ejecutados

# Deshabilitar la paginación de salida de AWS CLI
export AWS_PAGER=""

# Importamos las variables de entorno
source .env

# Crear grupo de seguridad: lb-sg (Balanceador)
aws ec2 create-security-group \
    --group-name $SECURITY_GROUP_LB \
    --description "Reglas para el balanceador de carga"

# Regla de acceso SSH para el balanceador
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_LB \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Regla de acceso HTTP para el balanceador
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_LB \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

#---------------------------------------------------------------------

# Crear grupo de seguridad: frontend-sg 
aws ec2 create-security-group \
    --group-name $SECURITY_GROUP_FRONTEND \
    --description "Reglas para el frontend"

# Regla de acceso SSH para frontend
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_FRONTEND \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Regla de acceso HTTP para frontend
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_FRONTEND \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

#---------------------------------------------------------------------

# Crear grupo de seguridad: nfs-sg 
aws ec2 create-security-group \
    --group-name $SECURITY_GROUP_NFS \
    --description "Reglas para el servidor NFS"

# Regla de acceso SSH para NFS
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_NFS \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Regla de acceso NFS para NFS
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_NFS \
    --protocol tcp \
    --port 2049 \
    --cidr 0.0.0.0/0

#---------------------------------------------------------------------

# Crear grupo de seguridad: backend-sg 
aws ec2 create-security-group \
    --group-name $SECURITY_GROUP_BACKEND \
    --description "Reglas para el backend"

# Regla de acceso SSH para backend
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_BACKEND \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Regla de acceso MySQL para backend
aws ec2 authorize-security-group-ingress \
    --group-name $SECURITY_GROUP_BACKEND \
    --protocol tcp \
    --port 3306 \
    --cidr 0.0.0.0/0

echo "Grupos de seguridad creados y configurados."
