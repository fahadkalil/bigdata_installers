#!/bin/bash

# Script para Ubuntu Linux para instalacao de programas para Big Data
clear

echo ">>>> INSTALANDO SOFTWARES PARA AULAS DE BIG DATA"

echo ">>>> Atualizando apt update"
sudo apt install -y curl wget git

echo ">>>> Instalando Java OpenJDK..."
sudo apt install openjdk-17-jdk -y &> /dev/null
java -version

echo ">>>> Instalando kcat e Apache Kafka (+ ZooKeeper)..."
sudo apt install -y kcat


curl https://dlcdn.apache.org/kafka/3.9.0/kafka_2.13-3.9.0.tgz --output kafka_2.13-3.9.0.tgz
tar xzf kafka_2.13-3.9.0.tgz
sudo mv kafka_2.13-3.9.0 /opt/kafka

echo ">>>> Instalando Apache Flink..."
curl https://dlcdn.apache.org/flink/flink-2.0.0/flink-2.0.0-bin-scala_2.12.tgz --output flink-2.0.0-bin-scala_2.12.tgz
tar xzf flink-2.0.0-bin-scala_2.12.tgz
sudo mv flink-2.0.0 /opt/flink

echo ">>>> Instalando mongodb-community..."
sudo apt install -y gnupg
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
   --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
sudo apt update &> /dev/null
sudo apt-get install -y mongodb-org
sudo systemctl start mongod
sudo systemctl status mongod

echo ">>>> Instalando client gui: MongoDB-Compass..."
wget https://downloads.mongodb.com/compass/mongodb-compass_1.45.4_amd64.deb
sudo apt install -y ./mongodb-compass_1.45.4_amd64.deb

echo ">>>> Instalando Apache Airflow ******"
python -V

echo "|  Criando e configurando virtualenv (venv): airflow-env"
if [ ! -d "$HOME/airflow-env" ]; then
	python -m venv airflow-env
	source ~/airflow-env/bin/activate
	pip install apache-airflow pandas
	echo "|  Verificando instalação do Airflow e desativando venv"
	airflow version
	deactivate
fi

echo ">>>> Instalando plataforma Data Build Tool (dbt)..."
if [ ! -d "$HOME/dbt-env" ]; then
	echo "|  Criando e configurando virtualenv (venv): dbt-env"
	python -m venv ~/dbt-env
	source ~/dbt-env/bin/activate
	pip install dbt-core dbt-postgres
	echo "|  Verificando instalação do dbt e desativando venv"
	dbt --version
	deactivate
fi

echo ">>>> Instalando Apache Spark, Jupyter e pacote delta-spark..."
sudo apt install scala
curl https://dlcdn.apache.org/spark/spark-3.5.5/spark-3.5.5-bin-hadoop3.tgz --output spark-3.5.5-bin-hadoop3.tgz
tar xzf spark-3.5.5-bin-hadoop3.tgz
sudo mv spark-3.5.5-bin-hadoop3 /opt/spark
echo "|  Verificando instalação do Apache Spark"
/opt/spark/bin/spark-shell --version

echo "|  Setando variáveis de ambiente"
echo "export SPARK_HOME=/opt/spark" >> ~/.bashrc
echo "export PATH=$SPARK_HOME/bin:$PATH" >> ~/.bashrc
echo "export PYSPARK_PYTHON=$(which python)" >> ~/.bashrc
echo "export PYSPARK_DRIVER_PYTHON=\"jupyter\"" >> ~/.bashrc
echo "export PYSPARK_DRIVER_PYTHON_OPTS=\"notebook\"" >> ~/.bashrc

source ~/.bashrc

if [ ! -d "$HOME/spark-env" ]; then
	echo "|  Criando e configurando virtualenv (venv): spark-env"
	python -m venv ~/spark-env
	source ~/spark-env/bin/activate
	pip install pyspark delta-spark jupyter findspark
	echo "|  Verificando instalação do PySpark e desativando venv"
	pyspark --version
	deactivate
fi

source ~/.bashrc &> /dev/null

echo " "
echo "#### INSTALAÇÕES FINALIZADAS! ####"
