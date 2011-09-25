#! /bin/sh
CMD="${1}"

if [ "${CMD}" = "update" ]; then
DOCUMENT_ID="${2}"
SENT=`date`
POST_URL="http://127.0.0.1/fax_documents/${DOCUMENT_ID}.xml"
DOCUMENT="<sent>${SENT}</sent>"

else
RAW_FILE="${2}"
DST="${3}"
SRC="${4}"
REMOTE_ID="${5}"
FAX_FILE="fax_from_${REMOTE_ID}.tif"
TOTAL_PAGES="${6}"
REC_PAGES="${7}"
SUCCESS="${8}"
RESULT_CODE="${9}"
RESULT_TEXT="${10}"
RECEIVED=`date`
POST_URL="http://127.0.0.1/fax_documents.xml"
DOCUMENT="<outgoing>false</outgoing><file>${FAX_FILE}</file><raw-file>${RAW_FILE}</raw-file><title>Fax from ${REMOTE_ID}</title><received>${RECEIVED}</received><destination>${DST}</destination><source>${SRC}</source>"

fi
POST_DATA="<?xml version=\"1.0\" > encoding=\"UTF-8\"?><fax-document>${DOCUMENT}</fax-document>"

curl --post302 -v --location-trusted -X POST -H 'Content-type: text/xml' -d "${POST_DATA}" "${POST_URL}"
