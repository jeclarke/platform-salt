import requests


def get_name_service(cm_host, cluster_name, service_name):
    """ Returns name service for HA Cluster """
    user_name = __salt__['pillar.get']('admin_login:user')
    password = __salt__['pillar.get']('admin_login:password')
    request_url = 'http://%s:8080/api/v1/clusters/%s/configurations/service_config_versions?service_name=%s' % (cm_host,
                                                                                   cluster_name,
                                                                                   service_name)

    r = requests.get(request_url, auth=(user_name, password))
    if r.status_code == 200:
        response = r.json()
        if 'items' in response:
            for item in response['items']:
                if item['is_current'] == True:
                    for config in item['configurations']:
                        if config['type'] == 'hdfs-site':
                            if 'dfs.nameservices' in config['properties']:
                                name_service = config['properties']['dfs.nameservices']
                                if name_service is not None and len(name_service) > 0:
                                    return name_service
    return None

def cluster_name():
    """Returns PNDA cluster name of the minion"""
    cname = __grains__['pnda_cluster']
    return cname

def namenodes_ips():
    """Returns hadoop name nodes ip addresses"""
    cm_name = cluster_name()
    cm_host = cloudera_manager_ip()
    service_name = 'HDFS'
    name_service = get_name_service(cm_host, cm_name, service_name) 
    if name_service:
        return [name_service]
    return ip_addresses('cloudera_namenode')

def cloudera_manager_ip():
    """ Returns the Cloudera Manager ip address"""
    cm = ip_addresses('cloudera_manager')
    if cm is not None and len(cm) > 0:
        return cm[0]
    else:
        return None

def kafka_brokers_ips():
    """Returns kafka brokers ip addresses"""
    return ip_addresses('kafka')

def kafka_zookeepers_ips():
    """Returns zookeeper ip addresses"""
    return ip_addresses('zookeeper')

def ldap_ip():
    """Returns the ip address of the LDAP server"""
    query = "G@roles:LDAP"
    result = __salt__['mine.get'](query, 'network.ip_addrs', 'compound').values()
    # Only get first ip address
    return result[0][0] if len(result) > 0 else None

def ip_addresses(role):
    """Returns ip addresses of minions having a specific role"""
    query = "G@pnda_cluster:{} and G@roles:{}".format(cluster_name(), role)
    result = __salt__['mine.get'](query, 'grains.items', 'compound').values()
    if len(result) > 0 and 'ec2' in result[0]:
        result = [r['ec2']['public_hostname'] if 'public_hostname' in r['ec2'] else r['ec2']['local_ipv4'] for r in result]
        return result

    query = "G@pnda_cluster:{} and G@roles:{}".format(cluster_name(), role)
    result = __salt__['mine.get'](query, 'network.ip_addrs', 'compound').values()
    # Only get first ip address
    result = [r[0] for r in result]
    return result if len(result) > 0 else None