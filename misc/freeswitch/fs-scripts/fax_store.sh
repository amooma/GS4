#! /bin/sh

RAW_FILE="$1"
FAX_FILE="fax_from_$3.tif"
DST="$2"
SRC="$3"

POST_URL="http://localhost/fax_documents.xml"
POST_DATA="<?xml version=\"1.0\" > encoding=\"UTF-8\"?><fax-document><outgoing>false</outgoing><file>$FAX_FILE</file><raw-file>$RAW_FILE</raw-file><title>Fax from $SRC</title></fax-document>"

curl -X POST -H 'Content-type: text/xml' -d "$POST_DATA" $POST_URL
