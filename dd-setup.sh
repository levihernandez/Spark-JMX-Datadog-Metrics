# Update the DD_API_KEY variable with your valid Datadog API Key before running the dd-setup.sh script

echo "${DD_API_KEY}, ${DD_SITE}"

if [[ ${DD_API_KEY} == "<datadog api key>" ]];then
    echo "You must provide a valid Datadog API Key see, https://app.datadoghq.com/account/settings#api"
    echo "Once you have a valid hey, modify the bashrc file and update the API Key: vi ~/.bashrc"
    exit 0
fi

# Show OS version and other information
lsb_release -a

# Create a workspace directory
mkdir Workspace; cd Workspace

# Update Ubuntu libraries
sudo apt-get update

# Install required packages
sudo apt-get install openjdk-8-jdk-headless scala git python3-pip -y

# Install Python PIP and modules
pip3 install Cython
pip3 install ddtrace
pip3 install datadog

# Install JMXTerm
wget https://github.com/jiaqi/jmxterm/releases/download/v1.0.2/jmxterm-1.0.2-uber.jar

# Install Spark 2.4, note that your download location may vary
# Please follow good practices, find your location when downloading to avoid unnecessary requests to sites
wget https://mirrors.sonic.net/apache/spark/spark-3.0.1/spark-3.0.1-bin-hadoop2.7.tgz
tar xvf spark-3.0.1-bin-hadoop2.7.tgz
sudo mv spark-3.0.1-bin-hadoop2.7 /opt/spark
rm spark-3.0.1-bin-hadoop2.7.tgz

# Validate Java installation
java -version; javac -version; scala -version; git --version

echo "Install Datadog ${DD_AGENT_MAJOR_VERSION}"

# Install Datadog agent, quick install
DD_AGENT_MAJOR_VERSION=${DD_AGENT_MAJOR_VERSION} DD_API_KEY=${DD_API_KEY} DD_SITE=${DD_SITE} bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

# Download the java tracer library, required by Spark
wget -O dd-java-agent.jar https://dtdg.co/latest-java-tracer

# Prepare Datadog YAML confs to collect logs, since we will run the PySpark in standalone mode, there is no need
# to enable the spark server configurations, where we normally should set the JMX, JAVA, and extraJavaOptions.
sudo cp /etc/datadog-agent/conf.d/spark.d/conf.yaml.example /etc/datadog-agent/conf.d/spark.d/conf.yaml
sudo cp /etc/datadog-agent/conf.d/jmx.d/conf.yaml.example /etc/datadog-agent/conf.d/jmx.d/conf.yaml

# restart the datadog agent & see status of integrations
sudo systemctl restart datadog-agent
sudo datadog-agent status
