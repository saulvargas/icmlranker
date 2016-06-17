

curl -s -X POST localhost:9200/icml2016/_search -d'
{
    "fields": [
       "_type", "_id"
    ],
   "from": 0,
   "size": 500,
   "query": {
      "filtered": {
         "query": {
            "match_all": {}
         },
         "filter": {
            "type": {
               "value": "library"
            }
         }
      }
   }
}' | jq -r -c '.hits | .hits | .[] | {_type: ._type, _id: ._id}' \
	| while read -r doc
do
	QUERY='
{
   "size": 10,
   "query": {
      "filtered": {
         "query": {
            "more_like_this": {
               "fields": [
                  "title",
                  "abstract",
                  "keywords"
               ],
               "like": '${doc}',
               "min_term_freq": 2,
               "max_query_terms": 10
            }
         },
         "filter": {
            "type": {
               "value": "proceedings"
            }
         }
      }
   }
}'
	curl -s -X POST localhost:9200/icml2016/_search -d "$QUERY" | jq -r -c '.hits | .hits | .[] | ._id + "\t" + (._source | .title)'
done | sort | uniq -c | sort -nr | head -n 20