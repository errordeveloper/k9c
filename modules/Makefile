.PHONY: weavecloud/include/weave-cloud.json

weavecloud/include/weave-cloud.json:
	mkdir -p weavecloud/include
	curl --silent --location \
	  "https://cloud.weave.works/k8s/v1.8/weave-cloud.json?service-token=DummyToken&omit-support-info=true" \
	  | jq -S "" \
	  | jq '.items[7].spec.template.spec.containers[0].args[0]={ "kubegen.String.Join": [ "--token=", { "kubegen.String.Lookup": "service-token" } ] }' \
	  | jq '.items[11].spec.template.spec.containers[0].args[4]={ "kubegen.String.Join": [ "https://", { "kubegen.String.Lookup": "service-token" }, "cloud.weave.works" ] }' \
	  | jq 'del(.items[18])' \
	  > "$@"
