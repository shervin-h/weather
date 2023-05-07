import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomCupertinoAlertDialog extends StatelessWidget {
  const CustomCupertinoAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.confirmText,
    this.cancelText,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  final Widget title;
  final String content;
  final String confirmText;
  final String? cancelText;
  final void Function() onConfirm;
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Container(
        padding: const EdgeInsets.all(8),
        width: context.width,
        height: context.width * 0.4,
        child: title,
      ),
      content: Text(
        content,
        style: context.textTheme.bodyText1!.copyWith(
          color: context.theme.colorScheme.onBackground.withOpacity(0.9),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: TextButton(
            onPressed: () {

            },
            child: Text(
              confirmText,
              style: context.textTheme.button!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (cancelText != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: TextButton(
              onPressed: onCancel ?? () { Navigator.of(context).pop(); },
              style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all<Color>(context.theme.errorColor.withOpacity(0.2))
              ),
              child: Text(
                cancelText!,
                style: context.textTheme.button!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],

    );
  }
}
