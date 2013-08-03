#/usr/bin/bash

url=lava.emc.com
pemFile=lava.emc.com.cert.pem
alias=lava-cert
javaHome=/usr/java/jre1.6.0_26
keystoreLocation=$javaHome/lib/security/cacerts
keytool=$javaHome/bin/keytool

if [ ! -d $javaHome ]; then
	echo 'Java not found at location: '$javaHome
	exit 1
fi


echo 'Attempting to download SSL Certificate from '$url
echo | openssl s_client -connect $url:443 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > $pemFile

if [ -f $pemFile ]; then
	echo 'PEM file created. Attempting to install certificate.'
	$keytool -import -file $pemFile -alias $alias -keystore $keystoreLocation
	rc=$?
	exit $rc
else
	echo 'Downlaod cert failed. PEM file not found on system.'
	exit 1
fi



