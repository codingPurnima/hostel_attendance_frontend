import 'dart:io'; // gives access to File class

import 'package:http/http.dart' as http;

class FaceService {
  final String baseUrl;

  FaceService({
    required this.baseUrl,
  }); //will be passed when creating the object later

  // takes captured photo and jwt token; returns true is success, false otherwise
  Future<bool> registerFace(File imageFile, String token) async {
    // creates a POST request of the type multipart/form-data
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/face/register'),
    );

    // sends token to backend (get_current_user asks for it; refer to backend code for realization)
    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      // request.files comes from http, it is a list; even if sending one file, you are adding it to the list.
      await http.MultipartFile.fromPath('file', imageFile.path),
      // converts your file into a format suitable for HTTP upload
    );

    var response = await request
        .send(); // actually sends data to backend; and gets a streamed response (streams are chunks of data)

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> verifyFace(File imageFile, String token) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/face/verify'),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

// upto here, everything same as register
    var response = await request
        .send(); // image and token go over network, /verify endpoint is triggered, it receives request- now in backend:
    // 1. first of all, authentication happens, current_user = Depends(get_current_user); This: extracts token, validates user, loads user from DB
    // 2. face embedding is generated, detection happens; stored embedding is fetched; comparision is done; result is sent """as http.StreamedResponse, not http.Response"""

    // convert response from stream to string (usable format)
    if (response.statusCode == 200) {
      final resBody = await response.stream.bytesToString();
      return {"data": resBody};
    }
    return null;
  }
}
