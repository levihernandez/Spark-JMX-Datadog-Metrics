# Spark-JMX-Datadog-Metrics
Monitoring Spark JMX Metrics with Datadog JMX integrations.

Using a base Vagrant box `ubuntu/bionic64`, we first update and install packages in preparation for our Spark Structured Streaming exercise. Most of the prerequisites will be provided in our `dd-setup.sh` script.

The goal of the current exercise is to present the multiple collection points for Spark in order to submit Spark metrics, custom business metrics, and monitor the health of the Spark system.

### Vagrant Prerequisites

* Create a directory `mkdir SparkDemo; cd SparkDemo`
* Initialize Vagrant `vagrant init ubuntu/bionic64`
* Start & SSH into the Vagrant host `vagrant up; vagrant ssh`

### Datadog Prerequisites

* Sign Up for a Datadog trial account
* Go to Integrations > [Agent](https://app.datadoghq.com/account/settings#agent)
* Go to Integrations > API > [API Keys](https://app.datadoghq.com/account/settings#api); create an API key that you will set for your `environment` and `datadog.yaml` configuration, this is for educational purposes and you must follow your company's policies on how to safeguard your API keys.

### Prerequisites `dd-setup.sh`

* Download the [dd-setup.sh](https://github.com/levihernandez/Spark-JMX-Datadog-Metrics/blob/main/dd-setup.sh) script and make it executable. The script performs the following:
    * Updates Ubuntu
    * Installs packages
        * OpenJDK 8, Scala 11, Git,  Python 3 PIP,  
        * Datadog Agent, Python modules (Cython, datadog, dd-trace, )
        * JMXTerm
        * Spark 2.4

### Configure Tools

* Configure Datadog JMX config YAML
* Modify PySpark streaming example if needed.
* 4 terminal sessions - Word count example with PySpark
    * Netcat traffic for ingestion of words
    * Execute PySpark Structured Streaming example
    * JMXTerm
    * Datadog restarts
* Dashboard Metrics



## Configure Datadog Config YAML

* Enable log collection in `datadog.yaml`

```yaml
vagrant@ubuntu-bionic:~/Workspace$ sudo vi /etc/datadog-agent/datadog.yaml
logs_enabled: true
```

* Enable log collection for Spark

```yaml
logs:
  - type: file
    path: /opt/spark/logs/*.out
    source: spark
    service: PySpark-Demo
```

* Enable JMX & Configure collection of JMX metrics

```yaml
vagrant@vgr-spark-base64:$ sudo vi /etc/datadog-agent/conf.d/jmx.d/conf.yaml
instances:
  - host: localhost
    port: 9178

    conf:
      - include:
          domain: metrics
          bean_regex: metrics\:name=.*\.spark\.streaming\..*\.states-usedBytes
          attribute:
            Value:
              metric_type: counter
              alias: "spark.structured.streaming.statesUsedBytes"
          tags:
            TypeRegex: $1
```
