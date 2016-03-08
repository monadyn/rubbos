rm -f /etc/systemd/system/docker.service
service docker status
systemctl daemon-reload
service docker restart
service docker status
