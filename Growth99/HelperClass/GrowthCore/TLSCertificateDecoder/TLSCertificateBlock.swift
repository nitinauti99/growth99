//
//  TLSCertificateBlock.swift
//  FargoCore-iOS
//
//  Created by SopanSharma on 4/14/20.
//

import Foundation

/* Typical structure of a X509 certificate and respective blocks https://docs.microsoft.com/en-us/windows/win32/seccertenroll/about-x-509-public-key-certificates
 
 ------------------------------------>
 SEQUENCE {
         CONTEXTSPECIFIC(0) {
             INTEGER : 1 bytes                                                          <------Version
         }
         INTEGER : 16 bytes                                                             <------SerialNumber
         SEQUENCE {
             OBJECTIDENTIFIER : 1.2.840.113549.1.1.11 (sha256WithRSAEncryption)         <------SignatureAlgo
             NULL
         }
         SEQUENCE {
             SET {
                 SEQUENCE {
                     OBJECTIDENTIFIER : 2.5.4.3 (commonName)
                     PRINTABLESTRING : Apple IST CA 2 - G1
                 }
             }
             SET {
                 SEQUENCE {
                     OBJECTIDENTIFIER : 2.5.4.11 (organizationalUnitName)
                     PRINTABLESTRING : Certification Authority
                 }
             }                                                                          <------Issuer
             SET {
                 SEQUENCE {
                     OBJECTIDENTIFIER : 2.5.4.10 (organizationName)
                     PRINTABLESTRING : Apple Inc.
                 }
             }
             SET {
                 SEQUENCE {
                     OBJECTIDENTIFIER : 2.5.4.6 (countryName)
                     PRINTABLESTRING : US
                 }
             }
         }
         SEQUENCE {
             UTCTIME : 2019-03-21 20:40:34 +0000                                        <------Validity Period
             UTCTIME : 2021-04-19 20:40:34 +0000
         }
         SEQUENCE {
             SET {
                 SEQUENCE {
                     OBJECTIDENTIFIER : 2.5.4.3 (commonName)
                     UTF8STRING : rss-cma.apple.com
                 }
             }
             SET {
                 SEQUENCE {
                     OBJECTIDENTIFIER : 2.5.4.11 (organizationalUnitName)
                     UTF8STRING : management:idms.group.811094
                 }
             }
             SET {                                                                      <------Subject
                 SEQUENCE {
                     OBJECTIDENTIFIER : 2.5.4.10 (organizationName)
                     UTF8STRING : Apple Inc.
                 }
             }
             SET {
                 SEQUENCE {
                     OBJECTIDENTIFIER : 2.5.4.8 (stateOrProvinceName)
                     UTF8STRING : California
                 }
             }
             SET {
                 SEQUENCE {
                     OBJECTIDENTIFIER : 2.5.4.6 (countryName)
                     PRINTABLESTRING : US
                 }
             }
         }
         SEQUENCE {
             SEQUENCE {
                 OBJECTIDENTIFIER : 1.2.840.113549.1.1.1 (rsaEncryption)
                 NULL                                                                   <------PublicKey
             }
             BITSTRING : 270 bytes
         }
         CONTEXTSPECIFIC(3) {
             ----------extensions-------------                                          <------Extensions https://docs.microsoft.com/en-us/windows/win32/seccertenroll/extensions
         }
     }
     SEQUENCE {
         OBJECTIDENTIFIER : 1.2.840.113549.1.1.11 (sha256WithRSAEncryption)
         NULL
     }
     BITSTRING : 256 bytes
 }
 <--------------------------------------
 */

enum TLSCertificateBlockPosition: Int {
    case version = 0
    case serialNumber = 1
    case signatureAlgorithm = 2
    case issuer = 3
    case date = 4
    case subject = 5
    case publicKey = 6
    case extensions = 7
}
