# Show OS version and other information
lsb_release -a
# Create a workspace directory
mkdir Workspace; cd Workspace
# Install required packages
sudo apt-get install openjdk-8-jdk-headless scala git -y
# Install Python PIP and modules
pip3 install Cython
pip3 install ddtrace
pip3 install datadog
# Validate Java installation
java -version; javac -version; scala -version; git --version
# Install Datadog agent, quick install
DD_AGENT_MAJOR_VERSION=${DD_AGENT_MAJOR_VERSION} DD_API_KEY=${DD_API_KEY} DD_SITE=${DD_SITE} bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"
# Download the java tracer library, required by Spark
wget -O dd-java-agent.jar https://dtdg.co/latest-java-tracer
# Prepare Datadog YAML confs to collect logs, since we will run the PySpark in standalone mode, there is no need 
# to enable the spark server configurations, where we normally should set the JMX, JAVA, and extraJavaOptions.
sudo cp /etc/datadog-agent/conf.d/spark.d/conf.yaml.example /etc/datadog-agent/conf.d/spark.d/conf.yaml
sudo cp /etc/datadog-agent/conf.d/jmx.d/conf.yaml.example /etc/datadog-agent/conf.d/jmx.d/conf.yaml
# restart the datadog agent
sudo systemctl restart datadog-agent
# Check status of the datadog agent
sudo datadog-agent status
