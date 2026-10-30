
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/foundation.dart';

class EmailService {
  static Future<Map<String, List<String>>> sendBulkEmails({
    required List<String> recipients,
    required String subject,
    required String body,
  }) async {
    final senderEmail = dotenv.env['SENDER_EMAIL'];
    final senderPassword = dotenv.env['SENDER_APP_PASSWORD'];

    if (senderEmail == null || senderPassword == null ||
        senderEmail.isEmpty || senderPassword.isEmpty) {
      throw Exception('Email credentials are missing in .env');
    }

    final smtpServer = gmail(senderEmail, senderPassword);

    final results = <String, List<String>>{
      'success': [],
      'failed': [],
    };

    for (final recipient in recipients) {
      try {
        final message = Message()
          ..from = Address(senderEmail)
          ..recipients.add(recipient)
          ..subject = subject
          ..text = body;

        await send(message, smtpServer);

        results['success']!.add(recipient);
      } catch (e, stackTrace) {
        debugPrint('Failed recipient: $recipient');
        debugPrint('SMTP Error: $e');
        debugPrint('Stack Trace: $stackTrace');

        results['failed']!.add(recipient);
      }
    }

    return results;
  }
}
