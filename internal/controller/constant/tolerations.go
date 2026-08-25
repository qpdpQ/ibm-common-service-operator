//
// Copyright 2026 IBM Corporation
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

const ServiceTolerationsTemplate = `
- name: ibm-im-operator
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.0
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.1
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.2
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.3
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.4
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.5
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.6
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.7
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.8
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.9
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.10
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.11
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.12
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.13
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.14
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.15
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.16
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.17
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-im-operator-v4.18
  spec:
    authentication:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.0
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.1
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.2
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.3
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.4
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.5
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.6
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.7
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.8
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.9
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.10
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.11
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.12
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.13
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.14
  spec:
    commonWebUI:
      tolerations: placeholder
- name: ibm-idp-config-ui-operator-v4.15
  spec:
    commonWebUI:
      tolerations: placeholder
- name: common-service-cnpg
  resources:
    - apiVersion: pg.ibm.com/v1
      kind: Cluster
      name: common-service-db
      data:
        spec:
          affinity:
            tolerations: placeholder
`
