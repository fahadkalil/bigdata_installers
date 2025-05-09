#!/bin/sh

clear
conda deactivate &> /dev/null

echo ">>>> INSTALANDO SOFTWARES PARA AULAS DE BIG DATA"
eval "$(curl -sLo- "https://git.io/progressbarposix")"
TOTAL_TASKS=15
bar__start

echo ">>>> Verificando se o brew está instalado e atualizado"
brew --version || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update &> /dev/null
bar__status_changed 1 $TOTAL_TASKS

echo ">>>> Instalando Java OpenJDK..."
brew install openjdk
echo "   Setar variáveis do Java"
eval "$(brew info openjdk | grep .zshrc | sed -e 's/^[ \t]*//')"
echo " ********"
echo " "
eval "$(brew info openjdk | grep openjdk.jdk | sed -e 's/^[ \t]*//')"
bar__status_changed 2 $TOTAL_TASKS

#echo "****** Instalando brew cask..."
#brew tap homebrew/cask

echo ">>>> Instalando kcat e Apache Kafka (+ ZooKeeper)..."
brew install kcat
bar__status_changed 3 $TOTAL_TASKS

brew install kafka
bar__status_changed 4 $TOTAL_TASKS

echo ">>>> Instalando Apache Flink..."
brew install apache-flink
bar__status_changed 5 $TOTAL_TASKS

echo ">>>> Instalando mongodb-community..."
brew tap mongodb/brew
brew update
brew install mongodb-community@8.0
bar__status_changed 6 $TOTAL_TASKS

echo ">>>> Instalando client gui: MongoDB-Compass..."
brew install --cask mongodb-compass
bar__status_changed 7 $TOTAL_TASKS

echo ">>>> Instalando postgresql@17..."
brew install postgresql@17

echo "|  Definindo PATH para binarios do postgresql@17"
eval "$(brew info postgresql@17 | grep .zshrc | sed -e 's/^[ \t]*//')"
source ~/.zshrc ; conda deactivate &> /dev/null

echo "|  Inicializando serviço: postgresql@17"
brew services start postgresql@17

echo "|  Criando usuario superuser: postgres@17"
createuser --superuser postgres &> /dev/null

echo "|  Reinicializando serviço: postgresql@17"
brew services restart postgresql@17
bar__status_changed 8 $TOTAL_TASKS

echo ">>>> Instalando client gui: pgAdmin4..."
brew install --cask pgadmin4

bar__status_changed 9 $TOTAL_TASKS

echo ">>>> Instalando Rust"
if [ ! -d "$HOME/.cargo" ]; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	. "$HOME/.cargo/env"
	cat "$HOME/.cargo/env" | grep export | sed -e 's/^[ \t]*//' >> ~/.zshrc
	source ~/.zshrc ; conda deactivate &> /dev/null
fi
bar__status_changed 10 $TOTAL_TASKS

echo ">>>> Instalando Apache Airflow ******"
echo "|  Instalando Python 3.12"
brew install python@3.12
bar__status_changed 11 $TOTAL_TASKS

echo "|  Criando e configurando virtualenv (venv): airflow-env"
if [ ! -d "$HOME/airflow-env" ]; then
	eval "cd ~ && $(brew info python@3.12 | grep libexec | sed -e 's/^[ \t]*//')/python3 -m venv airflow-env"
	source ~/airflow-env/bin/activate
	pip install apache-airflow pandas
	echo "|  Verificando instalação do Airflow e desativando venv"
	airflow version
	deactivate
fi
bar__status_changed 12 $TOTAL_TASKS

echo ">>>> Instalando plataforma Data Build Tool (dbt)..."
if [ ! -d "$HOME/dbt-env" ]; then
	echo "|  Criando e configurando virtualenv (venv): dbt-env"
	python3 -m venv ~/dbt-env
	source ~/dbt-env/bin/activate
	python -m pip install dbt-core dbt-postgres
	echo "|  Verificando instalação do dbt e desativando venv"
	dbt --version
	deactivate
fi
bar__status_changed 13 $TOTAL_TASKS

echo ">>>> Instalando Apache Spark e pacote delta-spark..."
if [ ! -d "$HOME/spark-env" ]; then
	echo "|  Criando e configurando virtualenv (venv): spark-env"
	python3 -m venv ~/spark-env
	source ~/spark-env/bin/activate
	python -m pip install pyspark delta-spark
	echo "|  Verificando instalação do PySpark e desativando venv"
	pyspark --version
	deactivate
fi
bar__status_changed 14 $TOTAL_TASKS

source ~/.zshrc ; conda deactivate &> /dev/null
bar__status_changed 15 $TOTAL_TASKS

echo " "
bar__stop
echo "#### INSTALAÇÕES FINALIZADAS! ####"
