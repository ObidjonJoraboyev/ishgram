import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
Future<void> sendPushMessage() async {
  try {
    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer AAAA9P-ov-k:APA91bEyBQJvBKb3t0ptFtaDB9f3sux-O0XbbOBalh7Anj95bkTDmngPB6XAGBvmGMDcu70-TXcKX-VztN6l6AY12zoegRZctBObfbfx12mbgTzpVd_CbFCgVyERhq8Ss0cktc-B0T8E',
      },
      body: jsonEncode(
          { "notification": {
            "body": "This is an FCM notification message!",
            "title": "FCM Message"
          },
            "to" : "duLlUQ8DDUQshQllm_Nw6h:APA91bH_E9jdijtU3UgQSuW12RlVjdQnn5ukgNNYLPiCroUkhGThD27nHDSbr2sor4XTFxNeeZ70nExdPa9wsNDH997_S-DQbtruPf5Gzje_-Eva7vKoSklXdEEtHBMABQ9w4CBVNRSj"
          }
      ),
    );

    if (response.statusCode == 200) {
    } else {
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}