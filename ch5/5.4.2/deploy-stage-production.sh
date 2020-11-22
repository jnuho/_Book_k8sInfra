#!/usr/bin/env bash
docker build -t 192.168.1.10:8443/echo-ip:latest .
docker push 192.168.1.10:8443/echo-ip
kubectl apply -f https://raw.githubusercontent.com/IaC-Source/jenkins-builder/main/echo-ip-development.yaml
for try in {1..30}
  do
    export ready=$(kubectl get deployment --selector=app=echo-ip-freestyle -n development -o jsonpath --template="{.items[0].status.readyReplicas}")
    echo "trying $try: ready $ready";
    if [ "$ready" == "1" ]; then
      exit 0
    fi
    sleep 1
done
exit 1