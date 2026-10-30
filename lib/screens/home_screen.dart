
import 'package:flutter/material.dart';

import '../services/email_service.dart';
import '../utils/email_validator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController subjectController =
  TextEditingController();

  final TextEditingController messageController =
  TextEditingController();

  bool isSending = false;

  int totalEmails = 0;

  List<String> successfulEmails = [];
  List<String> failedEmails = [];

  Future<void> sendEmails() async {
    final recipients =
    EmailValidator.parseEmails(emailController.text);

    final invalidEmails = recipients
        .where((email) => !EmailValidator.isValid(email))
        .toList();

    if (recipients.isEmpty) {
      showMessage('Please enter recipient emails');
      return;
    }

    if (invalidEmails.isNotEmpty) {
      showMessage('Invalid emails: ${invalidEmails.join(', ')}');
      return;
    }

    if (subjectController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty) {
      showMessage('Subject and message are required');
      return;
    }

    setState(() {
      isSending = true;
      successfulEmails.clear();
      failedEmails.clear();
      totalEmails = recipients.length;
    });

    try {
      final results = await EmailService.sendBulkEmails(
        recipients: recipients,
        subject: subjectController.text.trim(),
        body: messageController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        successfulEmails = results['success']!;
        failedEmails = results['failed']!;
      });
    } catch (e) {
      if (!mounted) return;
      showMessage('Sending failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bulk Email Sender',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              'Recipients',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: emailController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText:
                'Enter emails separated by commas or new lines',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Subject',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                hintText: 'Enter email subject',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Message',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: messageController,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Write your message here...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: isSending ? null : sendEmails,
                icon: isSending
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.send),
                label: Text(
                  isSending ? 'Sending...' : 'Send Emails',
                ),
              ),
            ),

            const SizedBox(height: 25),

            if (isSending) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 10),
              const Text('Please wait while emails are being sent...'),
            ],

            if (successfulEmails.isNotEmpty ||
                failedEmails.isNotEmpty) ...[

              const Divider(height: 35),

              Text(
                'Results ($totalEmails emails)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                'Successfully sent: ${successfulEmails.length}',
                style: const TextStyle(color: Colors.green),
              ),

              ...successfulEmails.map(
                    (email) => ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                  title: Text(email),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Failed: ${failedEmails.length}',
                style: const TextStyle(color: Colors.red),
              ),

              ...failedEmails.map(
                    (email) => ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  title: Text(email),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
