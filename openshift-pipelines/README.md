# Install tkn CLI

[Install tkn CLI](https://docs.redhat.com/en/documentation/red_hat_openshift_pipelines/1.20/html/pipelines_cli_tkn_reference/installing-tkn#installing-tkn-on-linux)

# OpenShift-Pipelines Operator Install

```
oc apply -f operator-install/install.yaml

oc patch console.operator cluster --type json -p '[{"op": "add", "path": "/spec/plugins", "value": ["pipelines-console-plugin"]}]'
```

# OpenShift-Pipelines Example

```
export GIT_USER="<git user>"
export GIT_TOKEN="<git token>"
export SOURCE_URL="<git repo URL>"
export IMAGE_FQDN="<image FQDN>"
export IMAGE_TAG="<image tag>"
export DOCKERCONFIG="<path to .dockerconfig.json>"

oc apply -f example/

oc project openshift-pipelines-example

oc create secret generic git-repo-token \
  --type=kubernetes.io/basic-auth \
  --from-literal=username=${GIT_USER} \
  --from-literal=password=${GIT_TOKEN}

oc annotate secret git-repo-token \
  tekton.dev/git-0="https://github.com" \
  -n openshift-pipelines-example

oc create secret generic registry-token \
  --from-file=.dockerconfigjson=${DOCKERCONFIG} \
  --type=kubernetes.io/dockerconfigjson

oc annotate secret registry-token \
  tekton.dev/docker-0="https://ghcr.io" \
  -n openshift-pipelines-example

oc get secret etc-pki-entitlement -n openshift-config-managed -o json | \
  jq 'del(.metadata.resourceVersion)' | jq 'del(.metadata.creationTimestamp)' | \
  jq 'del(.metadata.uid)' | jq 'del(.metadata.namespace)' | \
  oc -n openshift-pipelines-example create -f -

tkn pipeline start example-pipeline \
    -n openshift-pipelines-example \
    --serviceaccount pipeline \
    -p SOURCE_URL=${SOURCE_URL} \
    -p IMAGE_FQDN=${IMAGE_FQDN} \
    -p IMAGE_TAG=${IMAGE_TAG} \
    -w name=source,claimName=example-pipeline \
    -w name=rhel-entitlement,secret=etc-pki-entitlement
```