import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showCustomToast({
  required BuildContext context,
  required String message,
  bool isError = false,
}) {
  // BuildContext가 유효한지 확인
  if (!context.mounted) return;

  // Navigator의 컨텍스트를 사용
  final overlayContext = Navigator.of(context).overlay?.context;
  if (overlayContext == null) return;

  FToast fToast = FToast();
  fToast.init(overlayContext); // overlayContext 사용

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: isError ? const Color(0xFFFFE6E6) : const Color(0xFFF5E6D3),
    ),
    child: Text(
      message,
      style: TextStyle(
        color: isError ? const Color(0xFFB71C1C) : const Color(0xFF8B4513),
        fontSize: 16.0,
      ),
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: Duration(seconds: 2),
  );
}
