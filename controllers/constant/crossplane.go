//
// Copyright 2021 IBM Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

package constant

const CrossSubscription = `
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-crossplane-operator-app
  namespace: {{ .MasterNs }}
spec:
  channel: {{ .Channel }}
  installPlanApproval: Automatic
  name: ibm-crossplane-operator-app
  source: {{ .CatalogSourceName }}
  sourceNamespace: {{ .CatalogSourceNs }}
`

const CrossConfiguration = `
apiVersion: pkg.ibm.crossplane.io/v1
kind: Configuration
metadata:
  name: ibm-crossplane-bedrock-shim-config
  labels:
    ibm-crossplane-provider: {{ .CrossplaneProvider }}
spec:
  ignoreCrossplaneConstraints: false
  package: FromEnvVar
  packagePullPolicy: Always
  revisionActivationPolicy: Automatic
  revisionHistoryLimit: 1
  skipDependencyResolution: false
`

const CrossLock = `
apiVersion: pkg.ibm.crossplane.io/v1beta1
kind: Lock
metadata:
  name: lock
`

const CrossKubernetesProviderSubscription = `
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: crossplane-provider-kubernetes-operator
  namespace: {{ .MasterNs }}
spec:
  channel: {{ .Channel }}
  installPlanApproval: Automatic
  name: crossplane-provider-kubernetes-operator
  source: {{ .CatalogSourceName }}
  sourceNamespace: {{ .CatalogSourceNs }}
`

const CrossKubernetesProviderConfig = `
apiVersion: kubernetes.crossplane.io/v1alpha1
kind: ProviderConfig
metadata:
  finalizers:
    - in-use.crossplane.io
  name: kubernetes-provider
spec:
  credentials:
    source: InjectedIdentity
`

const CrossIBMCloudProviderSubscription = `
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: crossplane-provider-ibm-cloud-operator
  namespace: {{ .MasterNs }}
spec:
  channel: {{ .Channel }}
  installPlanApproval: Automatic
  name: crossplane-provider-ibm-cloud-operator
  source: {{ .CatalogSourceName }}
  sourceNamespace: {{ .CatalogSourceNs }}
`

const CrossIBMCloudProviderConfig = `
apiVersion: ibmcloud.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: ibm-crossplane-provider-ibm-cloud
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: {{ .MasterNs }}
      name: provider-ibm-cloud-secret
      key: credentials
  region: us-south
`
