#!/bin/bash

# kubeseal <./secret-argo-workflows-sso.yaml --scope strict --controller-name sealed-secrets-controller --controller-namespace sealed-secrets --format yaml >./argo-workflows-sso.yaml

kubeseal <./argo-workflows-sso.yaml --scope strict --cert ../../../../../runtime/base/sealed-secrets/master-crt/master.pem --format yaml > ./../argo-workflows-sso.yaml
