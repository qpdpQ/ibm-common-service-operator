#!/usr/bin/env bash

# Licensed Materials - Property of IBM
# Copyright IBM Corporation 2023. All Rights Reserved
# US Government Users Restricted Rights -
# Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
# This is an internal component, bundled with an official IBM product. 
# Please refer to that particular license for additional information. 

# ---------- Command arguments ----------
OC=oc

# ---------- Command variables ----------

# script base directory
BASE_DIR=$(cd $(dirname "$0")/$(dirname "$(readlink $0)") && pwd -P)

# counter to keep track of installation steps
NAMESPACE=""



# ---------- Main functions ----------

function main() {
    parse_arguments "$@"
    setup_mongo_pvc
    setup_mongo_deployment

}

function parse_arguments() {
    # process options
    while [[ "$@" != "" ]]; do
        case "$1" in
        -n)
            NAMESPACE=$1
            ;;
        -h | --help)
            print_usage
            exit 1
            ;;
        *) 
            echo "wildcard"
            ;;
        esac
        shift
    done
}


function setup_mongo_pvc() {
    STGCLASS=$(oc get pvc --no-headers=true mongodbdir-icp-mongodb-0 -n $NAMESPACE | awk '{ print $6 }')
	cat <<EOF | oc apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: cs-mongodump
  namespace: $NAMESPACE
  labels:
    foundationservices.cloudpak.ibm.com: mongo-data
spec:
  storageClassName: $STGCLASS
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
  volumeMode: Filesystem
EOF
}

function setup_mongo_deployment() {
    cat <<EOF | oc apply -f -
kind: Deployment
apiVersion: apps/v1
metadata:
  name: mongodb-backup
  namespace: $NAMESPACE
  labels:
    foundationservices.cloudpak.ibm.com: mongo-data
spec:
  selector:
    matchLabels:
      foundationservices.cloudpak.ibm.com: mongo-data
  template:
    metadata:
      annotations:
        backup.velero.io/backup-volumes: mongodump
        pre.hook.backup.velero.io/command: '["bash", "-c", "rm -rf /dump/dump/*; cat /cred/mongo-certs/tls.crt /cred/mongo-certs/tls.key > /work-dir/mongo.pem; cat /cred/cluster-ca/tls.crt /cred/cluster-ca/tls.key > /work-dir/ca.pem; mongodump --oplog --out /dump/dump --host mongodb:$MONGODB_SERVICE_PORT --username $ADMIN_USER --password $ADMIN_PASSWORD --authenticationDatabase admin --ssl --sslCAFile /work-dir/ca.pem --sslPEMKeyFile /work-dir/mongo.pem"]'
        post.hook.restore.velero.io/command: '["bash", "-c", "cat /cred/mongo-certs/tls.crt /cred/mongo-certs/tls.key > /work-dir/mongo.pem; cat /cred/cluster-ca/tls.crt /cred/cluster-ca/tls.key > /work-dir/ca.pem; mongorestore --db platform-db --host mongodb:$MONGODB_SERVICE_PORT --username $ADMIN_USER --password $ADMIN_PASSWORD --authenticationDatabase admin --ssl --sslCAFile /work-dir/ca.pem --sslPEMKeyFile /work-dir/mongo.pem /dump/dump/platform-db --drop"]'
      name: mongodb-backup
      namespace: $NAMESPACE
      labels:
        foundationservices.cloudpak.ibm.com: mongo-data
    spec:
      containers:
      - name: mongodb-backup
        image: icr.io/cpopen/cpfs/ibm-mongodb:4.2.1-mongodb.4.0.24
        command: ["bash", "-c", "sleep infinity"]
        volumeMounts:
        - mountPath: "/dump"
          subpath: dump
          name: mongodump
        - mountPath: "/cred/mongo-certs"
          name: icp-mongodb-client-cert
        - mountPath: "/cred/cluster-ca"
          name: cluster-ca-cert
        - mountPath: "/work-dir"
          name: tmp-mongodb
        env:
          - name: ADMIN_USER
            valueFrom:
              secretKeyRef:
                name: icp-mongodb-admin
                key: user
          - name: ADMIN_PASSWORD
            valueFrom:
              secretKeyRef:
                name: icp-mongodb-admin
                key: password
      volumes:
      - name: mongodump
        persistentVolumeClaim:
          claimName: cs-mongodump
      - name: icp-mongodb-client-cert
        secret:
          secretName: icp-mongodb-client-cert
      - name: cluster-ca-cert
        secret:
          secretName: mongodb-root-ca-cert
      - name: tmp-mongodb
        emptyDir: {}
EOF

}


main $*
