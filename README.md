# Bulk Email Sender

A simple Flutter application that allows users to send the same email message to multiple recipients simultaneously using Gmail SMTP.

Users can enter multiple email addresses, provide an email subject, write a message, and send individual emails with a single tap.

## Features

- **Multiple Recipients:** Enter multiple email addresses separated by commas or new lines.
- **Email Validation:** Validate email addresses and remove duplicates.
- **Custom Subject:** Specify the email subject.
- **Message Editor:** Write custom email messages.
- **Bulk Email Sending:** Send individual emails to multiple recipients.
- **Sending Status:** View successful and failed email attempts.
- **Secure Configuration:** Load sender credentials through environment configuration.

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter | Mobile application development |
| Dart | Programming language |
| Gmail SMTP | Email delivery |
| `mailer` | SMTP email integration |
| `flutter_dotenv` | Environment configuration |

## Project Structure

```text
bulk_email_sender/
│
├── lib/
│   ├── main.dart
│   │
│   ├── screens/
│   │   └── home_screen.dart
│   │
│   ├── services/
│   │   └── email_service.dart
│   │
│   ├── widgets/
│   │   ├── email_input.dart
│   │   ├── message_input.dart
│   │   └── send_button.dart
│   │
│   └── utils/
│       └── email_validator.dart
│
├── .env.example
├── .gitignore
├── pubspec.yaml
└── README.md
```

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Shunya-karan/BULKEMAILSENDER.git
```

Navigate to the project directory:

```bash
cd bulk_email_sender
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Gmail SMTP

Enable 2-Step Verification on your Google account.

Generate a Google App Password:

https://myaccount.google.com/apppasswords

Create a `.env` file in the project root:

```env
SENDER_EMAIL=your_email@gmail.com
SENDER_APP_PASSWORD=your_16_character_app_password
```

Use your Google App Password instead of your regular Gmail password.

### 4. Configure Environment Variables

Ensure `.env` is included in the Flutter assets section of `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true

  assets:
    - .env
```

**Important:** Never commit your actual `.env` file or Gmail App Password to GitHub. Add `.env` to `.gitignore`.

Flutter bundles declared assets into the application, so `.env` is not secure credential storage. This implementation is intended for private testing on a controlled device, not public distribution.

### 5. Run the Application

Connect an Android device or start an emulator.

Check available devices:

```bash
flutter devices
```

Run the application:

```bash
flutter run
```

## How to Use

1. Open the Bulk Email Sender application.
2. Enter multiple recipient email addresses.
3. Enter the email subject.
4. Write your message.
5. Click the **Send Emails** button.
6. View the successful and failed sending results.

### Example

**Recipients:**

```text
john@gmail.com
alex@gmail.com
example@yahoo.com
```

**Subject:**

```text
Important Announcement
```

**Message:**

```text
Hello,

I hope you are doing well.

I wanted to share some important information with you.

Regards
```

The application sends a separate email to each recipient, keeping their email addresses private.

## Building APK

To generate a release APK:

```bash
flutter build apk --release
```

APK location:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## Limitations

- Requires an active internet connection.
- Uses Gmail SMTP for email delivery.
- Gmail sending limits apply.
- Requires a valid Google App Password.
- Designed for Android rather than Flutter Web because the SMTP package requires raw socket support.
- SMTP acceptance does not guarantee inbox delivery.
- The current implementation does not provide persistent sending history.

## Security Notes

- Never use your regular Gmail password.
- Use Google App Passwords.
- Never commit `.env` or real credentials to GitHub.
- Do not distribute APKs containing your Gmail credentials.
- Only send emails to recipients who have agreed to receive them.

## Future Improvements

- Email sending history.
- Retry failed email attempts.
- HTML email support.
- Email attachment support.
- Better sending progress indicators.
- Scheduled email sending.

## License

This project is intended for personal use and learning purposes.
