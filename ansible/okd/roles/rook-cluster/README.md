

kubectl create secret generic rook-ceph-admission-controller \
        --from-file=key.pem=/tmp/rook-operator/files/server-key.pem \
        --from-file=cert.pem=/tmp/rook-operator/files/rook-ceph.crt


kubectl create -f /tmp/rook-operator/files/crds.yaml -f /tmp/rook-operator/files/common.yaml

./config-admission-controller.sh


oc create -f operator-openshift.yaml


oc label nodes worker-0.okd.example.com role=storage-node
oc label nodes worker-1.okd.example.com role=storage-node
oc label nodes worker-2.okd.example.com role=storage-node

oc create -f rbac.yaml

oc create -f cluster.yaml

oc create -f toolbox.yaml

kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash

oc create -f ceph-block.yaml

#oc create -f ceph-object.yaml
oc create -f object-openshift.yaml

oc create -f storageclass-bucket-delete.yaml

oc create -f object-bucket-claim-delete.yaml

oc create -f rgw-external.yaml

export AWS_HOST=$(kubectl -n default get cm ceph-bucket -o jsonpath='{.data.BUCKET_HOST}')
export AWS_ACCESS_KEY_ID=$(kubectl -n default get secret ceph-bucket -o jsonpath='{.data.AWS_ACCESS_KEY_ID}' | base64 --decode)
export AWS_SECRET_ACCESS_KEY=$(kubectl -n default get secret ceph-bucket -o jsonpath='{.data.AWS_SECRET_ACCESS_KEY}' | base64 --decode)

yum --assumeyes install s3cmd

export AWS_ENDPOINT=<endpoint>
kubectl -n rook-ceph get svc rook-ceph-rgw-my-store, then combine the clusterIP and the port.

echo "Susi Suess" > /tmp/susi

s3cmd put /tmp/susi --no-ssl --host=rook-ceph-rgw-my-store-rook-ceph.apps.okd.example.com --host-bucket= s3://ceph-bkt-aceb16e5-320e-4761-9f41-dc1187590671

s3cmd get s3://ceph-bkt-aceb16e5-320e-4761-9f41-dc1187590671/susi /tmp/susi-download --no-ssl --host=rook-ceph-rgw-my-store-rook-ceph.apps.okd.example.com --host-bucket=


s3cmd put /tmp/rookObj --no-ssl --host=rook-ceph-rgw-my-store-rook-ceph.apps.okd.example.com --host-bucket= s3://ceph-bkt-aceb16e5-320e-4761-9f41-dc1187590671

s3cmd get s3://ceph-bkt-aceb16e5-320e-4761-9f41-dc1187590671/rookObj /tmp/rookObj-download --no-ssl --host=rook-ceph-rgw-my-store-rook-ceph.apps.okd.example.com --host-bucket=

cat /tmp/rookObj-download 

oc create -f filesystem.yaml

oc create -f ceph-file.yaml

oc create -f route.yaml

ssh root@bastion "oc get secret rook-ceph-dashboard-password -o jsonpath=\"{['data']['password']}\" -n rook-ceph | base64 --decode && echo" > ~/okd-lab/.secrets/rook-dashboard


oc label namespace rook-ceph "openshift.io/cluster-monitoring=true"
