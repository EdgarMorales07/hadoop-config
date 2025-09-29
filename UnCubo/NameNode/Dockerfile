# Trabajamos sobre la imagen creada anteriormente
FROM hadoop-base-image:latest

MAINTAINER https://www.proyectoa.com

# Cambiamos al usuario root
USER root

# Definimos las variables
ENV HADOOP_VERSION 3.3.6
ENV LOG_TAG "[NameNode Hadoop_${HADOOP_VERSION}]:"
ENV BASE_DIR /opt/bd
ENV HADOOP_HOME ${BASE_DIR}/hadoop/
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop/
ENV DATA_DIR /var/data/hadoop/hdfs


# Creamos las carpetas para los datos de HDFS del NameNode y hacemos el usuario hdadmin propietario de ellas 
# En un entorno de producción se deberían crear varias carpetas en particiones separadas
RUN echo "$LOG_TAG Creando carpetas para los datos de HDFS del NameNode" && \
    mkdir -p ${DATA_DIR}/nn && chown -R hdadmin:hadoop ${DATA_DIR}

# Creamos la carpeta para los ficheros de log
#RUN echo "$LOG_TAG Creando la carpeta para los ficheros de log" && \
#    mkdir ${HADOOP_HOME}/logs

# Copiamos los ficheros de configuración y script de inicio
RUN echo "$LOG_TAG Copiando ficheros de configuración y script de inicio"
COPY Config-files/core-site.xml ${HADOOP_CONF_DIR}/core-site.xml
COPY Config-files/hdfs-site-namenode.xml ${HADOOP_CONF_DIR}/hdfs-site.xml
COPY Config-files/hadoop-env.sh ${HADOOP_CONF_DIR}/hadoop-env.sh

# Instala OpenSSH
RUN apt-get update && apt-get install -y openssh-server && \
    mkdir /var/run/sshd

# Permite login sin contraseña para root
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# Script de inicio
COPY Config-files/start-daemons-namenode.sh ${BASE_DIR}/start-daemons.sh

# Establecemos los permisos
RUN chmod +x ${BASE_DIR}/start-daemons.sh && \
    chown -R hdadmin:hadoop ${BASE_DIR}

# Preparamos los puertos que usaremos para los servicios web
EXPOSE 8020 9820 9870 9871

# Configuración de SSH para hdadmin
RUN mkdir -p /home/hdadmin/.ssh \
    && chown hdadmin:hadoop /home/hdadmin/.ssh \
    && chmod 700 /home/hdadmin/.ssh \
    && ssh-keygen -t rsa -P "" -f /home/hdadmin/.ssh/id_rsa \
    && cat /home/hdadmin/.ssh/id_rsa.pub >> /home/hdadmin/.ssh/authorized_keys \
    && chmod 600 /home/hdadmin/.ssh/authorized_keys \
    && chown hdadmin:hadoop /home/hdadmin/.ssh/authorized_keys

# Ajustar permisos para SSH
RUN chmod 600 /home/hdadmin/.ssh/authorized_keys && \
    chown hdadmin:hadoop /home/hdadmin/.ssh/authorized_keys


# Cambiamos al usuario hdadmin
#USER hdadmin

# Definimos las variables
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64/
ENV HADOOP_HOME ${BASE_DIR}/hadoop/
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop/
ENV PATH ${JAVA_HOME}/bin:${PATH}:${HADOOP_HOME}/bin/:${HADOOP_HOME}/sbin/

WORKDIR ${HADOOP_HOME}

RUN echo "$LOG_TAG Iniciando servicios"
CMD ["/opt/bd/start-daemons.sh"]
