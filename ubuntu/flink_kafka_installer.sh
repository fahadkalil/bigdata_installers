echo "### CRIANDO AMBIENTE COM APACHE FLINK E APACHE KAFKA ###"

echo ">>>> Instalando Python 3.11 (compatibilidade) + curl/wget"
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.11 python3.11-venv curl wget -y

echo ">>>> Instalando Java OpenJDK 17..."
sudo apt install openjdk-17-jdk -y &> /dev/null

echo ">>>> Acessando a pasta HOME do usuário..."
cd ~
echo ">>>> Instalando Apache Kafka..."
curl https://dlcdn.apache.org/kafka/3.9.0/kafka_2.13-3.9.0.tgz --output kafka_2.13-3.9.0.tgz
tar xzf kafka_2.13-3.9.0.tgz
sudo mv kafka_2.13-3.9.0 /opt/kafka
echo ">>>> Apache Kafka foi instalado em /opt/kafka"

echo ">>>> Instalando Apache Flink..."
curl https://dlcdn.apache.org/flink/flink-2.0.0/flink-2.0.0-bin-scala_2.12.tgz --output flink-2.0.0-bin-scala_2.12.tgz
tar xzf flink-2.0.0-bin-scala_2.12.tgz
sudo mv flink-2.0.0 /opt/flink
echo ">>>> Apache Flink foi instalado em /opt/flink"

cd ~
if [ ! -d "$HOME/flink-kafka-env" ]; then
  echo ">>>> Criando .venv com Python3.11 em ~/flink-kafka-env"
  mkdir flink-kafka-env
  cd aula_flink
  python3.11 -m venv .venv
  source .venv/bin/activate
  pip install apache-flink kafka-python
fi

echo "### AMBIENTE CRIADO APACHE FLINK E APACHE KAFKA CRIADO COM SUCESSO! ###"
