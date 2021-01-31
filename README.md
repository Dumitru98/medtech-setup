Hot to give jenkins user root privileges:
    sudo vi /etc/default/jenkins

    $JENKINS_USER="root"

    sudo chown -R root:root /var/lib/jenkins

    sudo chown -R root:root /var/cache/jenkins

    sudo chown -R root:root /var/log/jenkins

    service jenkins restart ps -ef | grep jenkins