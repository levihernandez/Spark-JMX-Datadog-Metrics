# Update the DD_API_KEY variable with your valid Datadog API Key before running the dd-setup.sh script
# Save environment variables to ~/.bashrc
echo """
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
export PYSPARK_PYTHON=/usr/bin/python3
export HOSTNAME=$(hostname)
export DD_API_KEY=${1}
export DD_SITE="datadoghq.com"
export DD_AGENT_MAJOR_VERSION=7
""" >> ~/.bashrc

echo "Run: source ~/.bashrc"
