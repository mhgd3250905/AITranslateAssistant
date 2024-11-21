import 'dart:convert';

import 'package:ai_18in_utils/utils/get_storage_instance.dart';
import 'package:get/get.dart';

class KVCtrl extends GetxController {
  String TAG = 'KVCtrl';

  static KVCtrl get to => Get.find();
  final descMapLive = Map<String, String>().obs;
  final specialMapLive = Map<String, String>().obs;

  final descCheckedLive = false.obs;
  final specialCheckedLive = false.obs;

  @override
  void onInit() {
    ever(descCheckedLive, (value) {
      GSIntance.getInstance().setBool(GSIntance.KEY_DESC_ENABLE, value);
    });
    ever(specialCheckedLive, (value) {
      GSIntance.getInstance().setBool(GSIntance.KEY_SPECIAL_ENABLE, value);
    });

    ever(descMapLive, (value) {
      String jsonStr = jsonEncode(value);
      GSIntance.getInstance().setString(GSIntance.KEY_DESC_MAP, jsonStr);
    });

    ever(specialMapLive, (value) {
      String jsonStr = jsonEncode(value);
      GSIntance.getInstance().setString(GSIntance.KEY_SPECIAL_MAP, jsonStr);
    });

    descCheckedLive.value =
        GSIntance.getInstance().getBool(GSIntance.KEY_DESC_ENABLE);
    specialCheckedLive.value =
        GSIntance.getInstance().getBool(GSIntance.KEY_SPECIAL_ENABLE);

    String descMapStr =
        GSIntance.getInstance().getString(GSIntance.KEY_DESC_MAP);
    if (descMapStr.isNotEmpty) {
      Map<String, dynamic> saveMap = jsonDecode(descMapStr);
      Map<String, String> stringMap = Map<String, String>.from(
        saveMap.map((key, value) => MapEntry(key, value.toString())),
      );
      descMapLive.value = stringMap;
    }

    String specialMapStr =
        GSIntance.getInstance().getString(GSIntance.KEY_SPECIAL_MAP);
    if (specialMapStr.isNotEmpty) {
      Map<String, dynamic> saveMap = jsonDecode(specialMapStr);
      Map<String, String> stringMap = Map<String, String>.from(
        saveMap.map((key, value) => MapEntry(key, value.toString())),
      );
      specialMapLive.value = stringMap;
    }
  }
}
