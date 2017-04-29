# certificate-master

_Docker container for creating an x509 certificate authority and zero to many certificates, signed by that authority_

## What Does It Do?

First checks to see if certificate authority files exist. If they don't, it will create a new certificate authority.  It then creates new certificates (from a list of certificate "common names"), unless they exist already.

Certificates are created in ```/certs```. It's a good idea to have this as a shared volume, so you can use the certificates in other containers.

The docker image exits once it has completed, and can be run any number of times without undue side effects.

## Environment Variables


* __CERTS__ List of common names to create new certificates.
* __AUTHORITY_NAME__ Certificate authority name
* __AUTHORITY_PASSWORD__ Certificate authority password
* __COMPANY__ Certificate authority company name
* __DEPARTMENT__ Certificate authority department
* __COUNTRY_CODE__ Certificate authority country code
* __STATE__ Certificate authority state
* __CITY__ Certificate authority city

## Example Use (With Docker Compose)

See example [Docker Compose](docker-compose.yml) file.

## Example Use (Wih Docker)

```
docker run \
  -v `pwd`/certs:/certs \
  -e CERTS='host1 host2 host3' \
  -e AUTHORITY_NAME=Automated \
  -e AUTHORITY_PASSWORD=PLEASE_CHANGE_ME \
  -e COMPANY=COMPANY_NAME \
  -e DEPARTMENT=Operations \
  -e COUNTRY_CODE=GB \
  -e STATE=London \
  -e CITY=London \
  certificatemaster_certs
```

### Volumes

As per the example [Docker Compose](docker-compose.yml) file, you'll want to have /certs as a volume, so you can use these certificates.

