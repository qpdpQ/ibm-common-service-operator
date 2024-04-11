./licensing/label-licensing-configmaps.sh ibm-licensing
./cert-manager/label-cert-manager.sh

oc label catalogsource ibm-operator-catalog foundationservices.cloudpak.ibm.com=catalog -n openshift-marketplace --overwrite=true
oc label catalogsource opencloud-operators foundationservices.cloudpak.ibm.com=catalog -n openshift-marketplace --overwrite=true
oc label catalogsource cloud-native-postgresql-catalog foundationservices.cloudpak.ibm.com=catalog -n openshift-marketplace --overwrite=true

oc label configmap common-service-maps -n kube-public foundationservices.cloudpak.ibm.com=configmap --overwrite=true
oc label configmap platform-auth-idp foundationservices.cloudpak.ibm.com=configmap --overwrite=true -n cs1

oc label namespace cs1 foundationservices.cloudpak.ibm.com=namespace --overwrite=true
oc label namespace ibm-cert-manager foundationservices.cloudpak.ibm.com=namespace --overwrite=true
oc label namespace ibm-licensing foundationservices.cloudpak.ibm.com=namespace --overwrite=true
oc label namespace tenant1 foundationservices.cloudpak.ibm.com=namespace --overwrite=true
oc label namespace tenant2 foundationservices.cloudpak.ibm.com=namespace --overwrite=true

oc label operatorgroup common-service foundationservices.cloudpak.ibm.com=operatorgroup --overwrite=true -n cs1
cert_mgr_og=$(oc get operatorgroup -A --no-headers | grep cert-manager | awk '{print $2}')
oc label operatorgroup ${cert_mgr_og} foundationservices.cloudpak.ibm.com=operatorgroup --overwrite=true -n ibm-cert-manager
licensing_og=$(oc get operatorgroup -A --no-headers | grep ibm-licensing | awk '{print $2}')
oc label operatorgroup ${licensing_og} foundationservices.cloudpak.ibm.com=operatorgroup --overwrite=true -n ibm-licensing

oc label subscriptions.operators.coreos.com ibm-cert-manager-operator foundationservices.cloudpak.ibm.com=singleton-subscription --overwrite=true -n ibm-cert-manager
oc label subscriptions.operators.coreos.com ibm-licensing-operator-app foundationservices.cloudpak.ibm.com=singleton-subscription --overwrite=true -n ibm-licensing
oc label subscriptions.operators.coreos.com ibm-common-service-operator foundationservices.cloudpak.ibm.com=subscription --overwrite=true -n cs1

oc label commonservices common-service foundationservices.cloudpak.ibm.com=commonservice --overwrite=true -n cs1
oc label customresourcedefinition commonservices.operator.ibm.com foundationservices.cloudpak.ibm.com=crd --overwrite=true

oc label customresourcedefinition issuers.cert-manager.io foundationservices.cloudpak.ibm.com=cert-manager --overwrite=true
oc label customresourcedefinition certificates.cert-manager.io foundationservices.cloudpak.ibm.com=cert-manager --overwrite=true

oc label customresourcedefinition zenservices.zen.cpd.ibm.com foundationservices.cloudpak.ibm.com=zen --overwrite=true
oc label customresourcedefinition zenextensions.zen.cpd.ibm.com foundationservices.cloudpak.ibm.com=zen --overwrite=true

oc label operandrequests common-service foundationservices.cloudpak.ibm.com=operand --overwrite=true -n cs1
oc label operandconfig common-service foundationservices.cloudpak.ibm.com=operand --overwrite=true -n cs1

oc label zenservice lite-zen foundationservices.cloudpak.ibm.com=zen --overwrite=true -n cs1