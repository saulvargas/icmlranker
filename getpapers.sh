#!/bin/bash

PROCEEDINGS="http://jmlr.org/proceedings/papers/v48/"

wget -O - http://jmlr.org/proceedings/papers/v48/ \
	| sed -n 's/.*href="\([^"]*\).*/\1/p' \
	| grep ".pdf" | grep -v supp.pdf \
| while read l
do
	if [[ $l == http* ]]
	then
		paper=$l
	else
		paper=${PROCEEDINGS}$l
	fi
	
	wget $paper
done