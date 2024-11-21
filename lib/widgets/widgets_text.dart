import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Win11TextDisplay extends StatelessWidget {
  final String text;

  Win11TextDisplay({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.centerRight,
            child: Win11Button(
              text: '复制',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('已复制到剪贴板')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Win11Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  Win11Button({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blue,
        // 按钮背景颜色
        textStyle: TextStyle(color: Colors.white),
        // 文字颜色
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // 圆角
        ),
        elevation: 0,
        // 去掉阴影
        side: BorderSide(color: Colors.blue.shade200, width: 1.0),
        // 边框
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // 内边距
      ),
      child: Icon(
        Icons.copy,
        color: Colors.blue,
      ),
    );
  }
}
