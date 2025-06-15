#!/bin/bash

# Симулируем создание пользователей через сертификаты
# (в Minikube не существует встроенной модели пользователей, используем сертификаты)

create_user_cert() {
  username=$1
  openssl genrsa -out ${username}.key 2048
  openssl req -new -key ${username}.key -out ${username}.csr -subj "/CN=${username}/O=${2}"
  openssl x509 -req -in ${username}.csr -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out ${username}.crt -days 365

  # Добавление пользователя в kubeconfig
  kubectl config set-credentials ${username} --client-certificate=${username}.crt --client-key=${username}.key
  kubectl config set-context ${username}-context --cluster=minikube --user=${username}
}

# Примеры
create_user_cert "devops-user" "devops"
create_user_cert "security-user" "security"
create_user_cert "qa-user" "qa"
create_user_cert "developer-user" "developers"
create_user_cert "teamlead-user" "teamleads"