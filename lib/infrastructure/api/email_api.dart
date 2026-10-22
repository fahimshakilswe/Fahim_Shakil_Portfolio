import 'dart:convert';

import 'package:aerium/infrastructure/failures/email_failure.dart';
import 'package:http/http.dart' as http;
import 'package:aerium/values/values.dart';

import 'email_model.dart';

abstract class EmailApi {
  ///portfolio-api-chi.vercel.app/api/getintouch
  Future<Email> sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  });
}

class EmailApiImpl implements EmailApi {
  final http.Client client;

  EmailApiImpl({required this.client});

  @override
  Future<Email> sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      final response = await client.post(
        Uri.parse("https://formsubmit.co/ajax/${StringConst.DEV_EMAIL}"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "subject": subject,
          "message": message,
          "_subject": "Portfolio Contact Form: $subject",
        }),
      );

      if (response.statusCode == 200) {
        return Email(status: "success");
      } else {
        throw EmailFailure.serverError();
      }
    } catch (e) {
      print("Errorss  ${e.toString()}");
      throw EmailFailure.serverError();
    }
  }
}
