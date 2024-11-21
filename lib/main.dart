import 'package:ai_18in_utils/controller_18in.dart';
import 'package:ai_18in_utils/controller_kv.dart';
import 'package:ai_18in_utils/page_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();


  runApp(
    GetMaterialApp(
      home: App(),
      routingCallback: (routing) {
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, widget) {
        return MediaQuery(
          //设置文字大小不随系统设置改变
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: widget!,
        );
      },
      // theme: ThemeData.dark().copyWith(
      //   shadowColor: Colors.black87,
      //   bottomAppBarColor: Colors.blueGrey[900],
      //   backgroundColor: Colors.grey[300],
      // ),
    ),
  );
}


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(T18InCtrl());
    Get.put(KVCtrl());
    return HomePage();
  }
}