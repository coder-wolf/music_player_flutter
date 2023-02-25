import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Future<String> recognizeSong(File audioFile) async {
  final url = Uri.parse('https://api.audd.io/');
  final token = 'c7a823d7a3d7d3f21dea79d7f262a625';
  print("===============================");

  // print("Audio file: $audioFile");

  final request = http.MultipartRequest('POST', url);
  request.fields['api_token'] = token;
  request.files.add(
    await http.MultipartFile.fromPath(
      'file',
      audioFile.path,
      // contentType: MediaType('audio', 'mp3'),
    ),
  );

  final response = await request.send();
  if (response.statusCode == 200) {
    final jsonResponse =
        await json.decode(await response.stream.bytesToString());
    print(jsonResponse);
    if (jsonResponse['result'] != null)
      return jsonResponse['result']['title'];
    else
      return "";
  } else {
    print("FAILED");
    throw Exception('Failed to recognize song.');
  }
}
