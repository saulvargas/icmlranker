#!/bin/bash

ACCESS_TOKEN="MSwxNDY2MTc0NDEzODU1LDI4NjYxNzYxLDI3OCxhbGwsLGh0dHBzOi8vaW50ZXJuYWwtZG9jcy1saXZlLm1lbmRlbGV5LmNvbSxjODctYWM1YzY4ZTU1NTEyZDFjOGI3MS1kZDY4NjhiYTQ5YjQ0M2UxLDBlOWE4Y2UyLTlhYzAtM2JlZC04NjQyLTEyN2U5N2E0ODk1OCxGUVpCTGRNQ1Uwd3A0SjVkM29RTFVaWldpMG8"

#proceedings="icml2016"

#me=$(curl -H "Authorization: Bearer ${ACCESS_TOKEN}" https://api.mendeley.com/profiles/me | jq -r -c '.id')

#curl 'https://api.mendeley.com/folders' \
#	-X POST \
#	-H "Content-Type: application/json" \
#	-H "Authorization: Bearer ${ACCESS_TOKEN}" \
#	-d "{'name' : '${proceedings}'}"

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
#	id=$(echo $metadata | jq -r -c '.id')
#	curl "https://api.mendeley.com/documents/${id}" \
#   		-X DELETE \
#   		-H "Authorization: Bearer ${ACCESS_TOKEN}"
#	echo $metadata >> proceedings.json
done

paste <(ls -1 *.pdf) proceedings.json > proceedings.txt