#!/bin/bash

ACCESS_TOKEN=""

curl "https://api.mendeley.com/documents?profile_id=${me}&limit=500&order=desc&sort=created" \
	-H "Authorization: Bearer ${ACCESS_TOKEN}" | jq -c '.[]' > library.json

for f in *.pdf
do
    curl 'https://api.mendeley.com/documents' \
   		-X POST \
   		-H "Authorization: Bearer ${ACCESS_TOKEN}" \
   		-H 'Content-Type: application/pdf' \
   		-H "Content-Disposition: attachment; filename=\"$f\"" \
   		--data-binary @$f >> proceedings.json
	echo >> proceedings.json
done

paste <(ls -1 *.pdf) proceedings.json > proceedings.txt