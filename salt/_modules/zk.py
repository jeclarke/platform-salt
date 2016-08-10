import requests

def zookeeper_quorum():
    """ Return list of ZK quorum """
    user_name = __salt__['pillar.get']('admin_login:user')
    password = __salt__['pillar.get']('admin_login:password')
    cm_host = __salt__['panda.cloudera_manager_ip']()
    cluster_name = __grains__['panda_cluster']

    request_url = 'http://%s:8080/api/v1/clusters/%s/services/ZOOKEEPER/components/ZOOKEEPER_SERVER' % (cm_host, cluster_name)

    zk_quorum = []
    r = requests.get(request_url, auth=(user_name, password))
    if r.status_code == 200:
        response = r.json()
        if 'host_components' in response:
            for host_component in response['host_components']:
                zk_quorum.append(host_component['HostRoles']['host_name'] + ':2181')
    return ",".join(zk_quorum)