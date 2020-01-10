Install-AdcsCertificationAuthority `
-CAType EnterpriseRootCa `
-CryptoProviderName "RSA#Microsoft Software Key Storage Provider" `
-KeyLength 2048 `
-HashAlgorithmName SHA1 `
-ValidityPeriod Years `
-ValidityPeriodUnits 3 `
-Force
