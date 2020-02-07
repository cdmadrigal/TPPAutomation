Install-AdcsCertificationAuthority `
-CAType EnterpriseRootCA `
-CryptoProviderName "RSA#Microsoft Software Key Storage Provider" `
-KeyLength 2048 `
-HashAlgorithmName SHA256 `
-ValidityPeriod Years `
-ValidityPeriodUnits 3 `
-Force
