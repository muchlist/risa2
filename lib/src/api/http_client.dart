import 'package:dio/dio.dart';
import '../config/constant.dart';
import '../globals.dart';

import 'json_parsers/json_parsers.dart';

class RequestREST {
  final String endpoint;
  final Map<String, dynamic> data;

  RequestREST({required this.endpoint, this.data = const {}});

  static final _client = Dio(BaseOptions(
    baseUrl: Constant.baseApiUrl,
    connectTimeout: 3000, // 3 second
    receiveTimeout: 5000,
    sendTimeout: 5000,
    headers: <String, String>{
      // "Authorization": "Bearer ${App.localStorage!.getString("token") ?? ""}",
      "Accept": "*/*",
      "Content-Type": "application/json"
    },
    followRedirects: false,
    validateStatus: (status) {
      return status! < 501;
    },
  ));

  // GET <<<<<<<<<<<
  Future<T> executeGet<T>(JsonParser<T> parser) async {
    try {
      final response = await _client.get<String>(
        endpoint,
        options: Options(
          headers: {
            "Authorization": "Bearer ${App.getToken() ?? ""}",
          },
        ),
      );
      return parser.parseFromJson(response.data ?? "");
    } on DioError catch (e) {
      return Future.error(_dioErrorHandler(e));
    } catch (e) {
      return Future.error(e);
    }
  }

  // POST <<<<<<<<<<<
  Future<T> executePost<T>(JsonParser<T> parser) async {
    // final formData = FormData.fromMap(data);
    try {
      final response = await _client.post<String>(
        endpoint,
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer ${App.getToken() ?? ""}",
          },
        ),
      );
      return parser.parseFromJson(response.data ?? "");
    } on DioError catch (e) {
      return Future.error(_dioErrorHandler(e));
    } catch (e) {
      return Future.error(e);
    }
  }

  // PUT <<<<<<<<<<<
  Future<T> executePut<T>(JsonParser<T> parser) async {
    // final formData = FormData.fromMap(data);
    try {
      final response = await _client.put<String>(
        endpoint,
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer ${App.getToken() ?? ""}",
          },
        ),
      );
      return parser.parseFromJson(response.data ?? "");
    } on DioError catch (e) {
      return Future.error(_dioErrorHandler(e));
    } catch (e) {
      return Future.error(e);
    }
  }

  // DELETE <<<<<<<<<<<
  Future<T> executeDelete<T>(JsonParser<T> parser) async {
    final response = await _client.delete<String>(
      endpoint,
      options: Options(
        headers: {
          "Authorization": "Bearer ${App.getToken() ?? ""}",
        },
      ),
    );
    return parser.parseFromJson(response.data ?? "");
  }

  // UPLOAD <<<<<<<<<<<
  Future<T> executeUpload<T>(JsonParser<T> parser) async {
    final formData = FormData.fromMap(data);

    try {
      final response = await _client.post<String>(
        endpoint,
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer ${App.getToken() ?? ""}",
          },
        ),
      );
      return parser.parseFromJson(response.data ?? "");
    } on DioError catch (e) {
      return Future.error(_dioErrorHandler(e));
    } catch (e) {
      return Future.error(e);
    }
  }

//   Future<String> uploadImage(File file) async {
//     String fileName = file.path.split('/').last;
//     FormData formData = FormData.fromMap({
//         "file":
//             await MultipartFile.fromFile(file.path, filename:fileName),
//     });
//     response = await dio.post("/info", data: formData);
//     return response.data['id'];
// }

  String _dioErrorHandler(DioError e) {
    if (e.type == DioErrorType.connectTimeout ||
        e.type == DioErrorType.receiveTimeout ||
        e.type == DioErrorType.sendTimeout) {
      return "Connection timeout";
    }
    if (e.message.contains("Connection refused")) {
      return "Connection refused";
    }

    return e.message;
  }
}
