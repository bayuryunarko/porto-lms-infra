#!/bin/bash
# ==============================================================================
# STARTUP SCRIPT: PROVISIONING LMS STAGING (GCP)
# ==============================================================================

exec > /var/log/startup-script.log 2>&1
set -x

echo "=== 1. Update OS & Install Dependensi Dasar ==="
apt-get update -y
apt-get upgrade -y
apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https jq

echo "=== 2. Install Google Cloud Ops Agent ==="
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
bash add-google-cloud-ops-agent-repo.sh --also-install

echo "=== 3. Install Docker Engine murni ==="
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker
systemctl start docker

echo "=== 4. Provisioning Stateful Services (PostgreSQL & Redis di luar K3s) ==="
mkdir -p /opt/lms-data/postgres-init
cat <<EOF > /opt/lms-data/postgres-init/init-multiple-dbs.sql
CREATE DATABASE auth_db;
CREATE DATABASE content_db;
CREATE DATABASE assessment_db;
EOF

docker run -d \
--name postgres-lms \
--restart unless-stopped \
-e POSTGRES_USER=admin \
-e POSTGRES_PASSWORD=${db_password} \
-p 5432:5432 \
-v /opt/lms-data/postgres-init:/docker-entrypoint-initdb.d \
postgres:15-alpine

docker run -d \
--name redis-lms \
--restart unless-stopped \
-p 6379:6379 \
redis:7-alpine

echo "=== 5. Install K3s (Stateless Orchestration) ==="
curl -sfL https://get.k3s.io | sh -
sleep 15
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

echo "=== 6. Install ArgoCD (Eksekutor GitOps) ==="
/usr/local/bin/kubectl create namespace argocd
/usr/local/bin/kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "=== PROVISIONING SELESAI ==="