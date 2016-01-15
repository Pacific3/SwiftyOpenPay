# SwiftyOpenPay

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![SwiftyOpenPay v0.2](https://img.shields.io/badge/Latest Version-v0.2-brightgreen.svg)](https://github.com/Pacific3/SwiftyOpenPay/releases/tag/v0.2)

**SwiftyOpenPay** is an ***unofficial*** OpenPay API client for iOS written in Swift.

Use at your own risk.

## Installation

`SwiftyOpenPay` can be installed using [Carthage](https://github.com/Carthage/Carthage).

In your Cartfile, include `SwiftyOpenPay`:

```
github "Pacific3/SwiftyOpenPay" ~> 0.2
```

Then, update:

```bash
$ carthage update
```

Drag all the `.framework` files at `Carthage/Build/iOS` to your target's `Linked Frameworks and Libraries` section.

## Usage

```swift
import SwiftyOpenPay

let myAddress = Address(
    line1: "1 Infinite Loop",
    city: "Cupertino",
    state: "California",
    countryCode: "US",
    postalCode: "95014"
)

let myCard = Card(
    holderName: "John Doe",
    expirationMonth: "12",
    expirationYear: "19",
    address: myAddress,
    number: "XXXXXXXXXXXX"
)

let openPay = SwiftyOpenPay(merchantId: "MyMerchantId", apiKey: "MyAPIKey")

do {
    try openPay.createTokenWithCard(myCard,
        completion: {token in
            print(token.id)
        },
        error: {error in
            print(error)
        }
    )
} catch {
    print(error)
}
```

# Disclaimer
SwiftyOpenPay is not an oficial [Openpay](http://www.openpay.mx) product. Openpay is not responsible for either this code or what you use it for.
The use of SwiftyOpenPay is your and only your responsability.

Openpay does provide an officially supported version of their iOS API client, which can be found over at [their GitHub page.](https://github.com/open-pay/openpay-ios)

Refer to Openpay's [Privacy Notice](http://www.openpay.mx/aviso-de-privacidad.html) and [Terms of Service](http://www.openpay.mx/terminos-servicio.html).
