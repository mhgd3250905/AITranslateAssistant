import 'package:ai_18in_utils/controller_kv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum KVType {
  desc,
  special,
}
extension KVTypeExtension on KVType {
  String getTitle() {
    switch (this) {
      case KVType.desc:
        return "词汇说明";
      case KVType.special:
        return "指定翻译";
      default:
        return "";
    }
  }

  String getValueLabel() {
    switch (this) {
      case KVType.desc:
        return "说明";
      case KVType.special:
        return "翻译";
      default:
        return "";
    }
  }
}

class KVListPage extends StatelessWidget {
  KVType kvType = KVType.desc;

  KVListPage({required this.kvType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kvType.getTitle()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _showAddDialog(context),
              child: Text('点击增加'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                Map<String, String> map = KVCtrl.to.descMapLive.value;
                switch(kvType){
                  case KVType.desc:
                    map = KVCtrl.to.descMapLive.value;
                    break;
                  case KVType.special:
                    map = KVCtrl.to.specialMapLive.value;
                    break;
                }
                if (map.isEmpty) {
                  return Center(child: Text('空'));
                }
                var keys = map.keys.toList();
                return ListView.builder(
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    final key = keys[index];
                    final value = map[key];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(key),
                        subtitle: Text(value!),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            switch(kvType){
                              case KVType.desc:
                                KVCtrl.to.descMapLive.remove(key);
                                KVCtrl.to.descMapLive.refresh();
                                break;
                              case KVType.special:
                                KVCtrl.to.specialMapLive.remove(key);
                                KVCtrl.to.specialMapLive.refresh();
                                break;
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final keyController = TextEditingController();
    final valueController = TextEditingController();

    Get.defaultDialog(
      title: '增加',
      content: Column(
        children: [
          TextField(
            controller: keyController,
            decoration: InputDecoration(
              labelText: '词汇',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: valueController,
            decoration: InputDecoration(
              labelText: kvType.getValueLabel(),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      textConfirm: 'Add',
      onConfirm: () {
        final key = keyController.text.trim();
        final value = valueController.text.trim();
        if (key.isNotEmpty && value.isNotEmpty) {
          switch(kvType){
            case KVType.desc:
              KVCtrl.to.descMapLive[key] = value;
              KVCtrl.to.descMapLive.refresh();
              break;
            case KVType.special:
              KVCtrl.to.specialMapLive[key] = value;
              KVCtrl.to.specialMapLive.refresh();
              break;
          }
          Get.back();
        } else {
          Get.snackbar('错误', '不能为空！');
        }
      },
      onCancel: () {
        Get.back();
      },
      buttonColor: Colors.blueGrey,
      confirmTextColor: Colors.white,
      cancelTextColor: Colors.black,
    );
  }
}
