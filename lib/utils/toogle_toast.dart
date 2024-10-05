import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class UtilityServices {
  void callToast(BuildContext context, String msg, String type) {
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      title: msg,
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.fillColored,
      alignment: Alignment.bottomCenter,
      type: type == "success"
          ? ToastificationType.success
          : type == "info"
              ? ToastificationType.info
              : ToastificationType.error,
    );
  }
}
