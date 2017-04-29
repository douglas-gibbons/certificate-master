#!/bin/bash -e

function cert {
  COMMON_NAME=$1
  FILENAME=$COMMON_NAME
  
  openssl genrsa -out ${FILENAME}.key 2048
  openssl req -new \
     -key ${FILENAME}.key \
     -out ${FILENAME}.csr \
     -subj "/C=${COUNTRY_CODE}/ST=${STATE}/L=${CITY}/O=${COMPANY}/OU=${DEPARTMENT}/CN=${COMMON_NAME}"

  openssl x509 -req -passin pass:${AUTHORITY_PASSWORD} -days 3650 \
    -in ${FILENAME}.csr -CA ca.crt -CAkey ca.key \
    -out ${FILENAME}.crt
}

[[ -d /certs ]] || mkdir /certs
cd /certs


# Only create a new CA if it does not exist
if ! test -f ca.key 
then

  openssl req -new -x509 \
   -passin pass:${AUTHORITY_PASSWORD} \
   -passout pass:${AUTHORITY_PASSWORD} \
   -extensions v3_ca -keyout ca.key -out ca.crt -days 3650 \
   -subj "/C=${COUNTRY_CODE}/ST=${STATE}/L=${CITY}/O=${COMPANY}/OU=${DEPARTMENT}/CN=${AUTHORITY_NAME}"

  echo "01" > ca.srl
fi


for CERT in $CERTS
do
  if ! test -f $CERT.key
  then
    echo "Creating certificate for $CERT"
    cert $CERT
  fi
done

ls -l /certs
