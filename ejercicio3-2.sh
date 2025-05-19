#!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
# Referencia: https://docs.aws.amazon.com/es_es/cli/latest/userguide/cliv2-migration.html#cliv2-migration-output-pager
export AWS_PAGER=""


# Obtener lista de instancias en ejecución con los nombres especificados
EC2_ID_LIST=$(aws ec2 describe-instances \
                --filters "Name=tag:Name,Values=loadbalancer,frontend-1,frontend-2,nfs-server,backend" \
                --query "Reservations[*].Instances[*].InstanceId" \
                --output text)


# Eliminamos todas las intancias que están en ejecución
aws ec2 terminate-instances \
    --instance-ids $EC2_ID_LIST


# Obtener lista de grupos de seguridad de la infraestructura
SG_ID_LIST=$(aws ec2 describe-security-groups \
                --filters "Name=group-name,Values=lb-sg,frontend-sg,nfs-sg,back-sg" \
                --query "SecurityGroups[*].GroupId" \
                --output text)


# Eliminar grupos de seguridad si existen
for ID in $SG_ID_LIST; do
    echo "Eliminando grupo de seguridad $ID..."
    aws ec2 delete-security-group --group-id $ID
done

echo "Infraestructura eliminada."
