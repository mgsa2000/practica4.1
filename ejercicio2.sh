#Crea una instancia EC2 para la máquina del Backend con las siguientes características.
#Identificador de la AMI: ami-08e637cea2f053dfa. Esta AMI se corresponde con la imagen Red Hat Enterprise #Linux 9 (HVM).
#Número de instancias: 1
#Tipo de instancia: t2.micro
#Clave privada: vockey
#Grupo de seguridad: backend-sg
#Nombre de la instancia: backend


aws ec2 run-instances \
    --image-id ami-08e637cea2f053dfa \
    --count 1 \
    --instance-type t2.micro \
    --key-name vockey \
    --security-groups backend-sg \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=backend}]"
