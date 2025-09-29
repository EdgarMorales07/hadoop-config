# Partimos del contenedor creado anteriormente
FROM hadoop-base-image:latest

MAINTAINER https://www.proyectoa.com

# Cambiamos al usuario root
USER root

# Definimos las variables de entorno
ENV HADOOP_VERSION 3.3.6
ENV LOG_TAG "[Resourcemanager Hadoop_${HADOOP_VERSION}]:"
ENV BASE_DIR /opt/bd
ENV HADOOP_HOME ${BASE_DIR}/hadoop/
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop/

# Creamos la carpeta para los ficheros de log
RUN echo "$LOG_TAG Creando carpeta para los ficheros de log" && \
    mkdir -p ${HADOOP_HOME}/logs

# Copiamos los ficheros de configuración y el script de inicio
RUN echo "$LOG_TAG Copiando los ficheros de configuración y el script de inicio"
COPY Config-files/core-site.xml ${HADOOP_CONF_DIR}/core-site.xml
COPY Config-files/yarn-site-resourcemanager.xml ${HADOOP_CONF_DIR}/yarn-site.xml
COPY Config-files/mapred-site-resourcemanager.xml ${HADOOP_CONF_DIR}/mapred-site.xml
COPY Config-files/hadoop-env.sh ${HADOOP_CONF_DIR}/hadoop-env.sh

# Instala OpenSSH
RUN apt-get update && apt-get install -y openssh-server && \
    mkdir /var/run/sshd

# Permite login sin contraseña para root y desactiva verificación de host
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# Copiamos el script de inicio
COPY Config-files/start-daemons-resourcemanager.sh ${BASE_DIR}/start-daemons.sh

# Establecemos los permisos
RUN chmod +x ${BASE_DIR}/start-daemons.sh && \
    chown -R hdadmin:hadoop ${BASE_DIR}

# Establecemos los puertos que se usarán para los servicios web
EXPOSE 8030 8031 8032 8033 8088 8090  

# Creamos el usuario no privilegiado
#RUN useradd -u 2000 hdadmin && \
    #mkdir -p /home/hdadmin && \
    #chown hdadmin:hadoop /home/hdadmin

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


# Definimos las variables de entorno para hdadmin
ENV JAVA_HOME /usr/lib/jvm/java-17-openjdk-amd64/
ENV HADOOP_HOME ${BASE_DIR}/hadoop/
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop/
ENV PATH ${JAVA_HOME}/bin:${PATH}:${HADOOP_HOME}/bin/:${HADOOP_HOME}/sbin/


# Cambiamos al directorio de trabajo
WORKDIR ${HADOOP_HOME}

# Ejecutamos los servicios
RUN echo "$LOG_TAG Iniciando demonios"
CMD ["/opt/bd/start-daemons.sh"]
# Cambiamos al usuario hdadmin
USER hdadmin

