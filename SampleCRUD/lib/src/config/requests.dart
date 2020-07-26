import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart';
import 'package:http_interceptor/http_client_with_interceptor.dart';
import './interceptor.dart';

const baseUrl = "http://localhost:3600/user/";

String getParamString(Map<String, dynamic> data) {
  String retVal = "?";
  data.forEach((key, value) {
    retVal += key + "=" + value.toString();
  });
  return retVal;
}

class HTTPReqs {
	// Client _client = Client(); // HTTP Client
	static Client _client = HttpClientWithInterceptor.build(
		interceptors: [AuthInterceptor()],
		retryPolicy: ExpiredTokenRetryPolicy()
	); // HTTP Interceptor Client

	static Future<Response> register(dio.FormData formData) {
		return _client.post("${baseUrl}register", body: formData);
	}

	static Future<Response> login(Map<String, String> data) {
		return _client.put("${baseUrl}login", body: data);
	}

	static Future<Response> forgotPassword(Map<String, String> data) {
		return _client.put("${baseUrl}forgot", body: data);
	}

	static Future<Response> logout(Map<String, dynamic> data) {
		return _client.get("${baseUrl}logout"+getParamString(data));
	}

	static Future<Response> getAllUsers(Map<String, dynamic> data) {
		return _client.get("${baseUrl}getAll"+getParamString(data));
	}

	static Future<Response> getUserDetails(Map<String, dynamic> data) {
		return _client.get("${baseUrl}getDetails"+getParamString(data));
	}

	static Future<Response> updateProfile(dio.FormData formData) {
		return _client.put("${baseUrl}updProf", body: formData);
	}

	static Future<Response> deleteAccount(Map<String, dynamic> data) {
		// return _client.delete("${baseUrl}delAcc", body: data);
		return _client.delete("${baseUrl}delAccPrms"+getParamString(data));
	}

	static Future<Response> refreshToken(String token) {
		return _client.get("${baseUrl}refresh", headers: {"token": token});
	}
}