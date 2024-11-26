import 'dart:convert';

import 'package:ai_18in_utils/bean/bean_t18in_result.dart';
import 'package:ai_18in_utils/bean/bean_translate.dart';
import 'package:ai_18in_utils/main.dart';
import 'package:ai_18in_utils/utils/get_storage_instance.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'bean/bean_translate_content.dart';
import 'enum_connect_state.dart';

class T18InCtrl extends GetxController {
  String TAG = 'T18InCtrl';

  static T18InCtrl get to => Get.find();

  final translateState = ConnectState.none.obs;

  ///获取记号结果
  final t18Result = T18Result.fromParams().obs;

  final filePathLive = ''.obs;

  final apiKey = ''.obs;

  final translateStepDesc = <String>[].obs;

  final modelIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    checkApiKey();
  }

  void checkApiKey() async {
    String saveApiKey =
        await GSIntance.getInstance().getString(GSIntance.API_KEY);
    apiKey.value = saveApiKey;
    apiKey.refresh();
  }

  //获取记号
  void translate(List<TranslateContent> translateContents) async {
    translateState.value = ConnectState.waiting;
    translateState.refresh();

    // 创建一个Dio实例
    Dio dio = Dio();

    // 定义请求的URL
    String url =
        'https://dashscope.aliyuncs.com/api/v1/apps/0ba3277817044a39a9df7a392fb50477/completion';

    switch (modelIndex.value) {
      case 0:
        url =
            'https://dashscope.aliyuncs.com/api/v1/apps/0ba3277817044a39a9df7a392fb50477/completion';
        break;
      case 1:
        url =
            'https://dashscope.aliyuncs.com/api/v1/apps/d7ad41638d244c93a5940f882e9180f9/completion';
        break;
    }

    // 设置请求头
    Map<String, String> headers = {
      'Authorization': apiKey.value, // 替换为您的实际API密钥
      'Content-Type': 'application/json',
    };

    // 将 User 对象列表转换为 List<Map<String, dynamic>>
    List<String> contentStrList =
        translateContents.map((user) => user.toJson()).toList();
    String prompt = jsonEncode(contentStrList);

    // 设置请求体
    Map<String, dynamic> data = {
      "input": {
        "prompt": prompt,
      },
      "parameters": {},
      "debug": {},
    };
    // 打印请求体
    print('Request Body: $data');

    try {
      // 发送POST请求
      //这里为了显示加载过程，可退
      var response = await dio.post(
        url,
        options: Options(headers: headers),
        data: data,
      );
      T18Result result = T18Result(response.data);
      t18Result.value = result;
      t18Result.refresh();

      if (result.output != null && result.output!.finish_reason == "stop") {
        translateState.value = ConnectState.done;
      } else {
        translateState.value = ConnectState.err;
      }
      translateState.refresh();
    } catch (e) {
      print(e);

      translateState.value = ConnectState.err;
      translateState.refresh();
    }
  }

  //获取记号
  Future<T18Result> translateBatch(
      List<TranslateContent> translateContents) async {
    // 创建一个Dio实例
    Dio dio = Dio();

    // 定义请求的URL
    String url =
        'https://dashscope.aliyuncs.com/api/v1/apps/0ba3277817044a39a9df7a392fb50477/completion';

    switch (modelIndex.value) {
      case 0:
        url =
            'https://dashscope.aliyuncs.com/api/v1/apps/0ba3277817044a39a9df7a392fb50477/completion';
        break;
      case 1:
        url =
            'https://dashscope.aliyuncs.com/api/v1/apps/d7ad41638d244c93a5940f882e9180f9/completion';
        break;
    }

    // 设置请求头
    Map<String, String> headers = {
      'Authorization': apiKey.value,
      'Content-Type': 'application/json',
    };

    // 将 User 对象列表转换为 List<Map<String, dynamic>>
    List<String> contentStrList =
        translateContents.map((user) => user.toJson()).toList();
    String prompt = jsonEncode(contentStrList);

    // 设置请求体
    Map<String, dynamic> data = {
      "input": {
        "prompt": prompt,
      },
      "parameters": {},
      "debug": {},
    };
    // 打印请求体
    // print('Request Body: $data');

    // 发送POST请求
    //这里为了显示加载过程，可退
    var response = await dio.post(
      url,
      options: Options(headers: headers),
      data: data,
    );

    T18Result result = T18Result(response.data);

    return result;
  }
}
