mine_functions:
  network.ip_addrs: [eth0]
  grains.items: []

logstash:
  version: 1.4.2
  directory: /opt/pnda

kibana:
  version: 4.1.6-linux-x64
  directory: /opt/pnda

elasticsearch:
  version: 1.5.0
  directory: /opt/pnda
  logdir: /var/log/elasticsearch
  datadir: /var/lib/elasticsearch
  confdir: /etc/elasticsearch
  workdir: /tmp/elasticsearch

jupyter:
  version: 4.2.0
  confdir: /usr/local/etc/jupyter
  kerneldir: /usr/local/share/jupyter/kernels

jupyterhub:
  version: 0.6.1
  confdir: /etc/jupyterhub

kafka:
  version: 0.9.0.1
  config:
    log_dirs:
      - '/var/kafka-logs'

kafkacontrib:
  release_directory: /opt/pnda
  release_version: logstash-1.4.2-contrib-kafka-0.7.5

admin_login:
  user: admin
  password: admin

kafkamanager:
  release_directory: /opt/pnda
  release_version: 1.3.0.8

opentsdb:
  version: 2.2.0RC1
  release_hash: sha256=199f60f31c8f72948d0e5a2c4695aedcb114360a77c4246b16587f07028f8068

grafana:
  version: 3.1.1-1470047149
  release_hash: sha256=4d3153966afed9b874a6fa6182914d9bd2e69698bbc7c13248d1b7ef09d3d328

gobblin:
  release_version: 0.1.0

console_frontend:
  release_version: 0.1.0

console_backend_data_logger:
  release_version: 0.1.0
  bind_port: 3001

console_backend_data_manager:
  release_version: 0.1.0
  bind_port: 3123

deployment_manager:
  release_version: 0.1.0

package_repository:
  release_version: 0.1.0

data-service:
  release_version: 0.1.0

hdfs_cleaner:
  release_version: 0.1.0

platform_testing:
  release_directory: /opt/pnda
  release_version: 0.1.0

ntp:
  servers:
    - "ntp.esl.cisco.com iburst"

platformlib:
  release_version: 0.1.0
  target_directory: "/opt/pnda"

nginx:
  admin_user: admin
  admin_password: admin
  certificates_email: pnda.team@external.cisco.com

jmxproxy:
  release_version: "3.2.0"
  release_hash: "sha512=97e69d7922f6515bc5ecaa9ab7326e2d61d275dd8d419bdb2fb246ec36dbc21cb8df45881a991623f1a8785744a618198094f16f37d5b66f3029516d8824b7a1"

anaconda:
  parcel_version: "4.0.0"
  parcel_repo: "http://54.229.30.212/anaconda_repo"
