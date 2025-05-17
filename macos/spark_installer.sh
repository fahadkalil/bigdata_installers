#!/bin/zsh

clear
conda deactivate &> /dev/null

echo ">>>> INSTALANDO APACHE SPARK PARA AULAS DE BIG DATA"
eval "$(curl -sLo- "https://git.io/progressbarposix")"
TOTAL_TASKS=3
bar__start

psql -U atitus -d postgres -c "ALTER DATABASE postgres OWNER TO postgres;" &> /dev/null

echo ">>>> Instalando linguagem Scala..."
brew install scala
bar__status_changed 1 $TOTAL_TASKS

echo ">>>> Instalando Apache Spark..."
brew install apache-spark
echo "|  Definindo PATH para SPARK_HOME"
eval "$(echo "export SPARK_HOME=$(echo "$(brew info apache-spark | grep -A 1 -m 1 "Installed" | tail -n 1 | sed -e 's/ (.*//')/libexec/")" >> ~/.zshrc)"
eval "$(echo "export PYTHON_PATH=$(echo "$(brew info apache-spark | grep -A 1 -m 1 "Installed" | tail -n 1 | sed -e 's/ (.*//')/libexec/python")" >> ~/.zshrc)"
source ~/.zshrc ; conda deactivate &> /dev/null
bar__status_changed 2 $TOTAL_TASKS

if [ -d "$HOME/spark-env" ]; then
	echo "|  Acessando virtualenv (venv): spark-env"
	echo "|  Baixando pacotes para Jupyter Notebook"
	python3 -m venv ~/spark-env
	source ~/spark-env/bin/activate
	python -m pip install jupyterlab findspark
	deactivate
fi
bar__status_changed 3 $TOTAL_TASKS

echo " "
bar__stop
echo "#### INSTALAÇÕES FINALIZADAS! ####"
