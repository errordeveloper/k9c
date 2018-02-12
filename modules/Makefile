.PHONY: weavecloud/include/weave-cloud.json

weavecloud/include/weave-cloud.json:
	mkdir -p weavecloud/include
	curl --silent --location \
	  "https://cloud.weave.works/k8s/v1.8/weave-cloud.json?service-token=DummyToken&omit-support-info=true" \
	  | jq -S "" \
	  | jq '.items[1].data.token={ "kubegen.String.AsBASE64": { "kubegen.String.Lookup": "service-token" } }' \
	  | jq 'del(.items[19])' \
	  > "$@"
