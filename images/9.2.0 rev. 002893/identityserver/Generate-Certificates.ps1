#Requires -RunAsAdministrator

$cert = New-SelfSignedCertificate -certstorelocation cert:\localmachine\my -dnsname 'sitecore-docker-devonly' -KeyUsage DigitalSignature,CertSign -KeyExportPolicy Exportable -Provider "Microsoft Strong Cryptographic Provider" `
-HashAlgorithm "SHA256";
$pwd = ConvertTo-SecureString -String 'secret' -Force -AsPlainText;
Export-PfxCertificate -cert $cert -FilePath '.\Files\root.pfx' -Password $pwd;

Write-Host $cert

.\Generate-Self-Signed-Certificate.ps1 -dnsName 'localhost' -file '.\Files\identity.pfx' -signer $cert
