#! /bin/sh

RAW_FILE="$1"
FAX_FILE="fax_from_$3.tif"
DST="$2"
SRC="$3"
RECEIVED=`date`

POST_URL="http://127.0.0.1/fax_documents.xml"
DOCUMENT="<outgoing>false</outgoing><file>$FAX_FILE</file><raw-file>$RAW_FILE</raw-file><title>Fax from $SRC</title><received>$RECEIVED</received><destination>$DST</destination>"
POST_DATA="<?xml version=\"1.0\" > encoding=\"UTF-8\"?><fax-document>$DOCUMENT</fax-document>"

curl --post302 -v --location-trusted -X POST -H 'Content-type: text/xml' -d "$POST_DATA" $POST_URL
