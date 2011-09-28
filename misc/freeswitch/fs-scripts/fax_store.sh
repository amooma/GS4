#! /bin/sh
CMD="${1}"
DST="${3}"
SRC="${4}"
REMOTE_ID="${5}"
TOTAL_PAGES="${6}"
REC_PAGES="${7}"
SUCCESS="${8}"
RESULT_CODE="${9}"
CAUSE_CODE="${10}"
RESULT_TEXT="${11}"
DATE=`date`

if [ "${CMD}" = "update" ]; then
	DOCUMENT_ID="${2}"
	POST_URL="http://127.0.0.1/fax_documents/${DOCUMENT_ID}.xml"
	if [ "${SUCCESS}" = "1" ]; then
		DOCUMENT="<sent>${DATE}</sent>"
	else
		DOCUMENT="<sent></sent>"
	fi
elif [ "${CMD}" = "create" ]; then
	RAW_FILE="${2}"
	FAX_FILE="fax_from_${REMOTE_ID}.tif"
	POST_URL="http://127.0.0.1/fax_documents.xml"
	DOCUMENT="<outgoing>false</outgoing><file>${FAX_FILE}</file><raw-file>${RAW_FILE}</raw-file><title>Fax from ${REMOTE_ID}</title><received>${DATE}</received><destination>${DST}</destination><source>${SRC}</source>"
else
	exit 1
fi

POST_DATA="<?xml version=\"1.0\" > encoding=\"UTF-8\"?><fax-document>${DOCUMENT}</fax-document>"

curl --post302 -v --location-trusted -X POST -H 'Content-type: text/xml' -d "${POST_DATA}" "${POST_URL}"
