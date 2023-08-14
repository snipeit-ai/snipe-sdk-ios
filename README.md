# SnipeSdk iOS 

`SnipeSdk` is a Swift package that provides functionality to interact with the Snipe database through API calls. It offers features such as signing up users, tracking events, and retrieving coin data.

## Installation

To use `SnipeSdk` in your iOS project, follow these steps:

1. Copy this repository link
    ```
    https://github.com/snipeit-ai/snipe-sdk-ios.git
    ```

2. Add the `SnipeSdk` package to your Xcode project.

3. Import the `SnipeSdk` module in your Swift code:

   ```swift
   import SnipeSdk
   ```

## Initialization

Before using any functions provided by `SnipeSdk`, you need to initialize it with your API key:

```swift
let apiKey = "YOUR_API_KEY"
let snipeSdk = SnipeSdk(apiKey: apiKey)
```

## Functions

### Sign Up

The `signUp` function in the SnipeSdk package allows you to create a document in the Snipe database by providing a hash value. This document serves as a record of user sign-up and is stored in the Snipe database for future reference. The function initiates an API call to the Snipe server and returns the unique identifier, known as `snipeId`, associated with the created document.

To generate a hash you can call the `generateHash` function with appropriate values for `userId`, `phone`, and `email` to generate a SHA-256 hash. Make sure to replace `your_secret_key_here` with your actual secret key.

```swift
import Foundation
import CommonCrypto

let HASH_KEY = "your_secret_key_here" // Adjust this secret key as needed

func generateHash(userId: String, phone: String, email: String) -> String {
    // Concatenate your variables
    let input = "\(userId).\(phone).\(email).\(HASH_KEY)"

    // Create a SHA-256 digest
    if let inputData = input.data(using: .utf8) {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        _ = inputData.withUnsafeBytes {
            CC_SHA256($0.baseAddress, UInt32(inputData.count), &digest)
        }

        // Convert the hash bytes to a hex string
        return bytesToHex(hash: digest)
    }

    return ""
}

func bytesToHex(hash: [UInt8]) -> String {
    let hexChars: [Character] = Array("0123456789ABCDEF")
    var result = ""

    for byte in hash {
        let i = Int(byte)
        result.append(hexChars[i >> 4 & 0x0F])
        result.append(hexChars[i & 0x0F])
    }

    return result
}

```

#### Parameters

- `hash` (Type: `String`): The hash value associated with the user's sign-up data. This hash acts as a unique identifier for the sign-up event and is used to create a document in the Snipe database.

#### Return Value

The `signUp` function returns a `String` representing the `snipeUserId` of the created document. This `snipeUserId` is a unique identifier that can be used to retrieve and manage the document in the Snipe database.

#### Usage 

```swift
let hash = "your_hash_value"
let signUpResponse = snipeSdk.signUp(hash: hash)
```


### Track Event

The `trackEvent` function in the SnipeSdk package allows you to track and trigger a specific event within the Snipe system. This function initiates an API call to the Snipe server and records the event details, such as the event ID, transaction amount, and partial percentage, if provided. It helps you monitor and manage various events within your application using the Snipe platform.

#### Parameters

- `eventId` (Type: `String`): The unique identifier for the event you want to track within the Snipe system.
- `snipeUserId` (Type: `String`): The unique identifier for the user who is triggering the event.
- `transactionAmount` (Type: `Int?`, Default: `nil`): The transaction amount associated with the event, if applicable.
- `partialPercentage` (Type: `Int?`, Default: `nil`): The partial percentage value for the event, if applicable.

#### Usage 

```swift
let eventId = "EVENT_ID"
let snipeUserId= "SNIPE_USER_ID"
let transactionAmount: Int? = 100
let partialPercentage: Int? = 50

snipeSdk.trackEvent(eventId: eventId,snipeUserId: snipeUserId, transactionAmount: transactionAmount, partialPercentage: partialPercentage)
```

This function tracks an event with an optional transaction amount and partial percentage. It doesn't return any value.

### Get Coin Data

The `getCoinData` function in the SnipeSdk package allows you to retrieve coin data associated with a specific Snipe user ID. This function initiates an API call to the Snipe server, requesting the user's token information. It returns a list of dictionaries containing details about the user's tokens, such as token values and IDs, which can be used for further processing or display within your application.

#### Parameters

- `snipeUserId` (Type: `String`): The unique identifier of the Snipe user for whom you want to retrieve coin data.

#### Return Value

- A list of dictionaries, where each dictionary contains token details:
  - `"value"` (Type: `NSNumber`): The value associated with the token.
  - `"token_id"` (Type: `String`): The unique identifier of the token.

#### Usage

```swift
let snipeUserId = "USER_SNIPE_ID"
let coinData = snipeSdk.getCoinData(snipeId: snipeId)
```

The `getCoinData` function returns an array of dictionaries, each containing coin data.


## Example

Here's an example of how to use the `SnipeSdk` package:

```swift
import SnipeSdk

let apiKey = "YOUR_API_KEY"
let snipeSdk = SnipeSdk(apiKey: apiKey)

let hash = "your_hash_value"
let signUpResponse = snipeSdk.signUp(hash: hash)

let eventId = "EVENT_ID"
let transactionAmount: Int? = 100
let partialPercentage: Int? = 50
snipeSdk.trackEvent(eventId: eventId, transactionAmount: transactionAmount, partialPercentage: partialPercentage)

let snipeUserId = "USER_SNIPE_ID"
let coinData = snipeSdk.getCoinData(snipeId: snipeId)
```

## Note

Make sure to replace `"YOUR_API_KEY"`, `"your_hash_value"`, `"EVENT_ID"`, and `"USER_SNIPE_ID"` with actual values from your application.
