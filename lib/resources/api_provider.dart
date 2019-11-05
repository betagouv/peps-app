import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiProvider {
  Client client = Client();
  final rootUrl = DotEnv().env['BACKEND_URL'];
  final defaultTimeout = Duration(seconds: 10);
  final authHeaders = {'Authorization': 'Api-Key ' + DotEnv().env['API_KEY']};
  final jsonHeaders = {'Content-Type': 'application/json'};
  static final ApiProvider _provider = ApiProvider._internal();

  factory ApiProvider() {
    return _provider;
  }

  ApiProvider._internal();

  Future<Response> fetchFormSchema() async {
    return client
        .get(
      Uri.http(rootUrl, '/api/v1/formSchema'),
      headers: authHeaders,
    )
        .timeout(defaultTimeout, onTimeout: () {
      return Response('', 408);
    });
  }

  Future<Response> sendTask(
      {String name, String phone, String answers: '', String email: '', String reason: '', String datetime: '', String practiceId}) async {
    return client
        .post(
      Uri.http(rootUrl, '/api/v1/sendTask'),
      headers: {}..addAll(authHeaders)..addAll(jsonHeaders),
      body: jsonEncode(
        {
          'answers': answers,
          'email': email,
          'name': name,
          'phone_number': phone,
          'datetime': datetime,
          'practice_id': practiceId,
          'reason': reason,
        },
      ),
    )
        .timeout(defaultTimeout, onTimeout: () {
      return Response('', 408);
    });
  }

  Future<Response> calculateRankings(Map formResults, List<String> practiceBlacklist, List<String> typeBlacklist) {
    return client
        .post(
      new Uri.http(rootUrl, '/api/v1/calculateRankings'),
      body: jsonEncode({
        'answers': formResults,
        'practice_blacklist': practiceBlacklist,
        'type_blacklist': typeBlacklist,
      }),
      headers: {}..addAll(authHeaders)..addAll(jsonHeaders),
    )
        .timeout(defaultTimeout, onTimeout: () {
      return Response('', 408);
    });
  }
}
