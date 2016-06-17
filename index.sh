#!/bin/bash

curl -X DELETE 'http://localhost:9200/icml2016?pretty'
curl -X PUT 'http://localhost:9200/icml2016?pretty'

while read -r doc
do
	id=$(echo "$doc" | cut -f1 | cut -f1 -d.)
	json=$(echo "$doc" | cut -f2 )
	curl -X PUT "http://localhost:9200/icml2016/proceedings/${id}?pretty" -d "$json"
done < proceedings.txt

while read -r doc
do
	id=$(echo $doc | jq -r '.id')
	curl -X PUT "http://localhost:9200/icml2016/library/${id}?pretty" -d "$doc"
done < library.json > log.txt