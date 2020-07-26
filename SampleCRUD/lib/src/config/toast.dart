import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

FlutterToast _flutterToast;

class CRUDToasts {

	static initToasts(context) {
		_flutterToast = FlutterToast(context);
	}

	static showToast(String message) {
		Widget toast = Container(
			padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.circular(25.0),
				color: Colors.greenAccent,
			),
			child: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					Icon(Icons.check),
					SizedBox(
						width: 12.0,
					),
					Text(message),
				],
			),
		);


		_flutterToast.showToast(
			child: toast,
			gravity: ToastGravity.BOTTOM,
			toastDuration: Duration(seconds: 3),
		);
	}
}