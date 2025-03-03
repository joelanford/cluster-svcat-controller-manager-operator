#!/bin/bash

if [ ! -f ./_output/tools/bin/yq ]; then
    mkdir -p ./_output/tools/bin
    curl -s -f -L https://github.com/mikefarah/yq/releases/download/2.4.0/yq_$(go env GOHOSTOS)_$(go env GOHOSTARCH) -o ./_output/tools/bin/yq
    chmod +x ./_output/tools/bin/yq
fi

FILES="config/v1/*.crd.yaml
authorization/v1/*.crd.yaml
console/v1/*.crd.yaml
operator/v1alpha1/*.crd.yaml
quota/v1/*.crd.yaml
security/v1/*.crd.yaml
"
for f in $FILES
do
    if [[ $(./_output/tools/bin/yq r $f spec.validation.openAPIV3Schema.properties.metadata.description) != "null" ]]; then
      echo "Error: cannot have a metadata description in $f"
      exit 1  
    fi
done
