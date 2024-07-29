#!/bin/bash

# Licensed Materials - Property of IBM
# Copyright IBM Corporation 2024. All Rights Reserved
# US Government Users Restricted Rights -
# Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
# This is an internal component, bundled with an official IBM product. 
# Please refer to that particular license for additional information. 

set -o errtrace
set -o nounset

# ---------- Command arguments ----------
OC=oc
YQ=jq

# Operator and Services namespaces
OPERATOR_NS=""
SERVICES_NS=""
CERT_MANAGER_NAMESPACE="ibm-cert-manager"
LICENSING_NAMESPACE="ibm-licensing"
LSR_NAMESPACE="ibm-lsr"

# catalog source image repository
CATALOG_SOURCE_IMAGE="docker-na-public.artifactory.swg-devops.com/hyc-cloud-private-daily-docker-local/ibmcom/ibm-common-service-catalog"

# subscription channel
SUB_CHANNEL=v3

# Catalog sources and namespace
CS_SOURCE_NS="openshift-marketplace"

# temporary git repository location
GIT_REPO_DIR=tmp/git

# rook ceph git repository
ROOK_CEPH_REPO=https://github.com/rook/rook.git

# ---------- Command variables ----------

# script base directory
BASE_DIR=$(cd $(dirname "$0")/$(dirname "$(readlink $0)") && pwd -P)

# ---------- Main functions ----------

source ${BASE_DIR}/env.properties

function main() {
    pre_req
    install
}


function pre_req(){

    title "Start to validate the parameters passed into script... "
    # Checking oc command logged in
    user=$($OC whoami 2> /dev/null)
    if [ $? -ne 0 ]; then
        error "You must be logged into the OpenShift Cluster from the oc command line"
    else
        success "oc command logged in as ${user}"
    fi
    if [ "$OPERATOR_NS" == "" ]; then
        error "Must provide operator namespace"
    else
        if ! $OC get namespace $OPERATOR_NS &>/dev/null; then
            error "Operator namespace $OPERATOR_NS does not exist, please provide a valid namespace"
        fi
    fi

    if [ "$SERVICES_NS" == "" ]; then
        warning "Services namespace is not provided, will use operator namespace as services namespace"
        SERVICES_NS=$OPERATOR_NS
    fi
}

function install() {
    title "Backup and Restore environment setup"
    msg ""
    check_prereqs
    install_storageclass
    create_catalog_source
    create_common_service_maps
    create_namespace "${CS_NAMESPACE}"
    create_operator_group
    create_storage_class
    create_pull_secrets
    enable_deprecated_api_monitor
    install_common_service_operator
    update_common_service_profile
    install_operators
    install_zen
    show_cluster_info
    msg "-----------------------------------------------------------------------"
    success "Install completed"
    exit 0
}

# ---------- Supporting functions ----------
function create_storage_class() {

     # check supported platform
    amd64_nodes=$(oc get no -l "kubernetes.io/arch=amd64" --no-headers --ignore-not-found)
    if [[ -z "${amd64_nodes}" ]]; then
        error "Rook ceph storage can only be installed on amd64 cluster"
    fi

    # checking if rook-ceph is already installed
    if [[ ! -z "$(oc get sc -o name | grep 'rook-ceph')" ]]; then
        error "rook-ceph storage is already installed"    
    fi

    # clone rook-ceph
    title "Cloning rook-ceph git repository ..."
    msg "-----------------------------------------------------------------------"

    if [[ -d "${GIT_REPO_DIR}/rook" ]]; then
        # delete rook-ceph repository
        rm -rf "${GIT_REPO_DIR}/rook"
    fi

    if [[ ! -d "${GIT_REPO_DIR}/rook" ]]; then
        # clone rook-ceph repository
        mkdir -p "${GIT_REPO_DIR}"
        cd "${GIT_REPO_DIR}"
    fi

    git clone --single-branch --branch release-1.12 ${ROOK_CEPH_REPO}

    check_return_code "$?" "Error cloning rook-ceph repo ${ROOK_CEPH_REPO}"

    # install rook-ceph
    if [[ -d "${GIT_REPO_DIR}/rook/deploy/examples" ]]; then
        cd ${GIT_REPO_DIR}/rook/deploy/examples

        #remove pool field

        if [[ ! -z "${DOCKER_HUB_USER}" ]] && [[ ! -z "${DOCKER_HUB_TOKEN}" ]]; then
            if [[ -z "$(oc get project rook-ceph --ignore-not-found --no-headers)" ]]; then
                oc new-project rook-ceph
            fi
            ${BASE_DIR}/../bin/create_dockerhub_secret.sh rook-ceph default
        fi

        oc create -f crds.yaml
        oc create -f common.yaml
        oc create -f operator-openshift.yaml
        oc create -f cluster.yaml
        oc create -f ./csi/rbd/storageclass.yaml
        oc create -f ./csi/rbd/pvc.yaml -n rook-ceph
        oc create -f filesystem.yaml
        oc create -f ./csi/cephfs/storageclass.yaml
        oc create -f ./csi/cephfs/pvc.yaml -n rook-ceph
        oc create -f toolbox.yaml

        # workaround to avoid rook-ceph-crashcollector stuck in initializing
        # oc -n rook-ceph create secret generic --type kubernetes.io/rook rook-ceph-crash-collector-keyring

        check_return_code "$?" "Error installing rook-ceph"

        # annotates rook-cephfs as default storage class if a default storage class is not set
        if [[ -z "$(oc get sc | grep '(default)')" ]]; then
            oc annotate sc rook-cephfs storageclass.kubernetes.io/is-default-class=true
        fi 

        oc get sc

        success "Done"
    else
        echo "${GIT_REPO_DIR}/rook/deploy/examples"
        error "Unable to locate rook-ceph installation resources"
    fi

}
