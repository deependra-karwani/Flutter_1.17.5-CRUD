import './requests.dart';
import './sharedPref.dart';
import 'package:http_interceptor/http_interceptor.dart';

class AuthInterceptor extends InterceptorContract {
	@override
	Future<RequestData> interceptRequest({RequestData data}) async {
		final token = MyPreferences.getSingle('token');

		if(token != '') {
			data.headers['token'] = token;
		}

		return data;
	}

	@override
	Future<ResponseData> interceptResponse({ResponseData data}) async => data;

	// @override
	// Future<ResponseData> interceptResponse({ResponseData data}) async {
	// 	if(data.statusCode == 401) {
	// 		final data = await RefreshToken API;
	// 		prefs.saveSingle('token', <token from RefreshToken Response>);
	// 		data.headers['token'] = <token from RefreshToken Response>;
	// 	}

	// 	return data;
	// }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
	@override
	Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
		if (response.statusCode == 401) {
      final tkn = MyPreferences.getSingle('token');
      final data = await HTTPReqs.refreshToken(tkn);
      MyPreferences.saveSingle('token', data.headers['token']);
      return true;
		}

		return false;
	}
}