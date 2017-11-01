{% set pnda_mirror = pillar['pnda_mirror']['base_url'] %}
{% set misc_packages_path = pillar['pnda_mirror']['misc_packages_path'] %}
{% set mirror_location = pnda_mirror + misc_packages_path %}

{% set app_version = salt['pillar.get']('kylin:release_version', '2.1.0') %}
{% set app_directory_name = 'kylin-' + app_version %}
{% if pillar['hadoop.distro'] == 'HDP' %}
{% set app_package = 'apache-kylin-2.1.0-bin-hbase1x.tar.gz' %}
{% set app_directory_name = 'apache-kylin-2.1.0-bin-hbase1x' %}
{% else %}
{% set app_package = 'apache-kylin-2.1.0-bin-cdh57.tar.gz' %}
{% set app_directory_name = 'apache-kylin-2.1.0-bin-cdh57' %}
{% endif %}

{% set package_url = mirror_location + app_package %}

{% set install_dir = pillar['pnda']['homedir'] %}

kylin-dl_and_extract:
  archive.extracted:
    - name: {{ install_dir }}
    - source: {{ package_url }}
    - source_hash: {{ package_url }}.sha512.txt
    - archive_format: tar
    - tar_options: v
    - if_missing: {{ install_dir }}/{{ app_directory_name }}

kylin-create_directory_perms:
  file.directory:
    - name: {{ install_dir }}/{{ app_directory_name }}
    - mode: 777
    - replace: False

kylin-create_directory_perms_tomcat_temp:
  file.directory:
    - name: {{ install_dir }}/{{ app_directory_name }}/tomcat/temp
    - mode: 777
    - replace: False

kylin-create_directory_perms_tomcat_logs:
  file.directory:
    - name: {{ install_dir }}/{{ app_directory_name }}/tomcat/logs
    - mode: 777
    - replace: False

kylin-create_directory_perms_tomcat_conf:
  file.directory:
    - name: {{ install_dir }}/{{ app_directory_name }}/tomcat/conf
    - mode: 777
    - replace: False

kylin-create_directory_perms_tomcat_webapps:
  file.directory:
    - name: {{ install_dir }}/{{ app_directory_name }}/tomcat/webapps
    - mode: 777
    - replace: False


kylin-create_link:
  file.symlink:
    - name: {{ install_dir }}/kylin
    - target: {{ install_dir }}/{{ app_directory_name }}

kylin-stop:
  cmd.run:
    - name: sudo -u hdfs {{ install_dir }}/kylin/bin/kylin.sh stop | true

kylin-start:
  cmd.run:
    - name: sudo -u hdfs {{ install_dir }}/kylin/bin/kylin.sh start