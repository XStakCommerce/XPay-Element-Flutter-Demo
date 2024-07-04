# About

Experience seamless in-app payments with our XPay Payments Demo, an example application showcasing the robust capabilities of the XPay Element for Flutter. This app demonstrates how easily payments can be integrated and customized within any Flutter application, ensuring a smooth and secure transaction experience that perfectly matches your app’s design and user expectations.

## How To integrate XPay Flutter SDK

XPay Element for Flutter is an embedded payment system that allows you to collect payments directly from users within your Flutter applications. This package is highly customizable, enabling you to tailor the appearance and functionalities of the payment form to align seamlessly with your app's style and theme.

## Features

### Seamless Payment Integration

Easily integrate payment functionalities into your Flutter app without redirecting users to external applications or pages.

### Custom Styling

Style the payment SDK according to your app's theme with customizable labels, placeholders, and more.

### Embedded Authentication

Conduct OTP authentication within your app, ensuring a smooth and secure user experience.

### Event Handling

Utilize built-in events such as onBinDiscount and onReady to dynamically manage changes and validate inputs.

## Getting started

To incorporate the XPay embedded payment system into your Flutter application, start by adding the following dependency to your pubspec.yaml file:

```dart
dependencies:
  xpay_element_flutter_stage: 0.0.2
```

## Usage

To use the XPay SDK in your app, follow these steps:

### Import the Package

```dart
import 'package:xpay_element_flutter_stage/xpay_element_flutter_stage.dart';
```

### Initialize the Element Controller

Create an instance of XPayElementController with necessary credentials available on your XPay dashboard:

```dart
final XPayElementController controller = XPayElementController(
  publicKey: "your_account_public_key",
  hmacKey: "your_account_hmac_key",
  accountId: "your_account_id"
);
```

### Embed the Payment Widget

Integrate XPayElementWidget into your app's widget tree and configure it with the controller:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('XPay Payment Example')),
    body: XPayElementWidget(controller: controller),
  );
}
```

## Custom Styling

Customize the SDK's appearance to seamlessly integrate with your app's style and theme. The XPay SDK allows you to modify elements' style and appearance, making it adaptable to various design requirements.

### Initializing and Applying Custom Styles

Initialize XPayElementCustomStyle and pass custom style configurations to its constructor. Below is an example of how you can tailor the appearance of your payment elements:

```dart
@override
  XPayElementCustomStyle elementCustomStyle =
      XPayElementCustomStyle.configureCustomStyle({
    "inputConfiguration": {
      "cardNumber": {
        "label": "Card Number",
        "placeholder": "Enter card number"
      },
      "expiry": {"label": "Expiry Date", "placeholder": "MM/YY"},
      "cvc": {"label": "CVC", "placeholder": "Enter cvc"}
    },
    "inputStyle": {
      "height": 40,
      "textColor": 0xff000000,
      "textSize": 16,
      "fontWeight": 400,
      "borderColor": 0xffe6e6e6,
      "borderRadius": 5,
      "borderWidth": 1
    },
    "inputLabelStyle": {
      "fontSize": 16,
      "fontWeight": 400,
      "textColor": 0xff000000
    },
    "onFucusInputStyle": {
      "textColor": 0xff000000,
      "textSize": 16,
      "fontWeight": 400,
      "borderColor": 0xffc8dbf9,
      "borderWidth": 1
    },
    "invalidStyle": {
      "borderColor": 0xffff0000,
      "borderWidth": 1,
      "textColor": 0xffff0000,
      "textSize": 14,
      "fontWeight": 400
    },
    "errorMessageStyle": {
      "textColor": 0xffff0000,
      "textSize": 14,
      "fontWeight": 400
    }
  });
```

### Applying the Custom Styles

After configuring your styles, apply them to the XPayElementWidget to enhance the user interface:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Custom Styled XPay Element')),
    body: XPayElementWidget(style: elementCustomStyle, controller: controller)
  );
}
```

The above styling properties are all optional; you can define only those you require, ensuring flexibility and customization according to your specific design needs.

## Element Events

Handle element-specific events to enhance the user experience:

### onReady Event

This event triggers when all form fields are valid and the form is ready for submission.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Custom Styled XPay Element')),
    body: XPayElementWidget(
            controller: controller,
            onReady: (bool isReady) {
                // Update your state to enable payment submission
            },
        )
    );
}
```

### onBinDiscount

Receive data related to the card's BIN as the user inputs their card number, which can be used for implementing discounts or promotional offers.

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Custom Styled XPay Element')),
    body: XPayElementWidget(
            controller: controller,
            onBinDiscount: (dynamic binDiscountData) {
                // Process and apply BIN-based discounts
            },
        )
    );
}
```

## Confirming Payment

To proceed with the payment confirmation when all form fields are valid and the onReady event has returned true, you should perform a few necessary steps. First, ensure you have initiated a server-side API call to create a payment intent. This create intent API is responsible for generating the `clientSecret` and `encryptionKey`, which are critical for securing the payment confirmation.

### Server-Side Payment Intent Creation

Before invoking the payment confirmation on the client side, your backend should call the create intent API to obtain:

`clientSecret`: A secret key used to initiate the payment process securely.
`encryptionKey`: Used to encrypt sensitive information before it is transmitted.

### Confirming the Payment

Once you have the necessary keys from your backend, use the XPayElementController initialized earlier to call the confirmPayment method. Here’s how you can implement this in your Flutter app:

```dart
void confirmPayment() async {
  try {
    // Assuming 'controller' is your instance of XPayElementController
    var paymentResponse = await controller.confirmPayment(
      customerName: "Customer Name",
      clientSecret: "client_secret_from_intent_api",
      encryptionKeys: "encryption_keys_from_intent_api"
    );

    if (paymentResponse.error) {
      // Handle payment failure
      print("Payment failed: ${paymentResponse.message}");
    } else {
      // Handle payment success
      print("Payment successful: ${paymentResponse.message}");
    }
  } catch (e) {
    // Handle exceptions
    print("Payment Error: $e");
  }
}

```

### Confirm Payment Response

The response from confirmPayment contains two keys:

`error`: A boolean that indicates whether the payment was unsuccessful. If true, it means the payment failed.
`message`: A string containing a message from the server. This message provides details about the payment outcome or error information.

## Clean Method

The `clear` method is used to reset the payment form. This is especially useful if you have a button designed to clear the form or reset the checkout process.

```dart
// Assuming 'controller' is your instance of XPayElementController
controller.clear();
```
