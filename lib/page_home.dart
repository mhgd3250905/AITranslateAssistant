import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ai_18in_utils/bean/bean_t18in_result.dart';
import 'package:ai_18in_utils/bean/bean_translate.dart';
import 'package:ai_18in_utils/bean/bean_translate_content.dart';
import 'package:ai_18in_utils/controller_18in.dart';
import 'package:ai_18in_utils/controller_kv.dart';
import 'package:ai_18in_utils/enum_connect_state.dart';
import 'package:ai_18in_utils/page_kv_list.dart';
import 'package:ai_18in_utils/utils/get_storage_instance.dart';
import 'package:excel/excel.dart' as EXCEL;
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/widget_dropdown_btn.dart';
import 'widgets/widgets_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _inputController;

  String? _selectedOption = "英文 (English)";

  final List<String> _options = [
    '中文 (Simplified Chinese)',
    '英文 (English)',
    '日文 (Japanese)',
    '韩文 (Korean)',
    '法文 (French)',
    '德文 (German)',
    '西班牙文 (Spanish)',
    '意大利文 (Italian)',
    '葡萄牙文 (Portuguese)',
    '俄文 (Russian)',
    '阿拉伯文 (Arabic)',
    '荷兰文 (Dutch)',
    '印度尼西亚文 (Indonesian)',
    '泰文 (Thai)',
    '越南文 (Vietnamese)',
    '波兰文 (Polish)',
    '土耳其文 (Turkish)',
    '捷克文 (Czech)',
    '希腊文 (Greek)',
    '瑞典文 (Swedish)',
    '丹麦文 (Danish)',
    '挪威文 (Norwegian)',
    '芬兰文 (Finnish)',
    '罗马尼亚文 (Romanian)',
    '匈牙利文 (Hungarian)',
    '保加利亚文 (Bulgarian)',
    '斯洛伐克文 (Slovak)',
    '斯洛文尼亚文 (Slovenian)',
    '克罗地亚文 (Croatian)',
    '塞尔维亚文 (Serbian)',
    '乌克兰文 (Ukrainian)',
    '白俄罗斯文 (Belarusian)',
    '丹麦文 (Danish)',
    '立陶宛文 (Lithuanian)',
    '拉脱维亚文 (Latvian)',
    '埃及文 (Egyptian Arabic)',
    '伊朗文 (Persian)',
    '乌尔都文 (Urdu)',
    '印地文 (Hindi)',
    '孟加拉文 (Bengali)',
    '马来文 (Malay)',
    '菲律宾文 (Filipino)',
    '印度尼西亚文 (Indonesian)',
    '希伯来文 (Hebrew)',
    '泰米尔文 (Tamil)',
    '旁遮普文 (Punjabi)',
    '高棉文 (Khmer)',
    '缅甸文 (Burmese)',
    '老挝文 (Lao)',
    '马达加斯加文 (Malagasy)',
  ];

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            buildApikeyContainer(),
            const SizedBox(height: 20.0),
            buildInputContainer(),
            const SizedBox(height: 20.0),
            buildTranslateBtn(),
            const SizedBox(height: 20.0),
            buildTextDisplay(),
            const SizedBox(height: 20.0),
            buildFilePicker(),
            const SizedBox(height: 20.0),
            buildLogContainer(),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }


  Widget buildLogContainer() {
    return Obx(() {
      var translateSteps = T18InCtrl.to.translateStepDesc.value;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 300.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.grey),
                ),
                padding: EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: translateSteps.map((line) {
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              line,
                              style: TextStyle(
                                  color: Colors.green, fontSize: 14.0),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  /**
   * 选择Excel文件
   */
  Widget buildFilePicker() {
    return Obx(() {
      String filePath = T18InCtrl.to.filePathLive.value;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Text(
                '已选择: $filePath',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _downloadFile,
              child: Text('下载模板文件'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('选择Excel文件'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _parseExcelFile,
              child: Text('开始解析'),
            ),
          ],
        ),
      );
    });
  }

  bool _isDownloading = false;
  String _downloadMessage = '';

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      T18InCtrl.to.filePathLive.value = result.files.single.path ?? '';
      T18InCtrl.to.filePathLive.refresh();
    } else {}
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 不允许点击外部关闭
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // 设置圆角
          ),
          contentPadding: EdgeInsets.all(16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(), // 加载指示器
              SizedBox(height: 16.0),
              Text("正在翻译..."), // 加载提示文字
            ],
          ),
        );
      },
    );
  }

  void _showTextDialog(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: true, // 允许点击外部关闭
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // 设置圆角
          ),
          title: Text("提示", style: TextStyle(fontSize: 18.0)),
          content: Text(
            msg,
            style: TextStyle(fontSize: 16.0),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("确定"),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _parseExcelFile() async {
    T18InCtrl.to.translateStepDesc.value.clear();
    T18InCtrl.to.translateStepDesc.refresh();
    String apikey = GSIntance.getInstance().getString(GSIntance.API_KEY);
    if (apikey.isEmpty) {
      _showTextDialog(Get.context!, "请先配置大模型Api Key!");
      return;
    }
    if (T18InCtrl.to.filePathLive.value.isEmpty) {
      _showTextDialog(Get.context!, "请选择Excel文件");
      return;
    }

    _showLoadingDialog(Get.context!);

    T18InCtrl.to.translateStepDesc.value.add('开始读取Excel文件');
    T18InCtrl.to.translateStepDesc.refresh();
    int tokens = 0;

    var bytes = File(T18InCtrl.to.filePathLive.value).readAsBytesSync();
    var excel = EXCEL.Excel.decodeBytes(bytes);

    List<String> languageList = [];
    List<String> words = [];
    for (var table in excel.tables.keys) {
      // print(table); //sheet Name
      if (excel.tables[table] == null) continue;
      var maxColumns = excel.tables[table]?.maxColumns ?? 0;
      print("Max Column = $maxColumns");
      print("Max Row = ${excel.tables[table]?.maxRows}");
      var rows = excel.tables[table]?.rows;
      if (rows == null || rows.isEmpty) {
        return;
      }
      var isFinish = false;
      for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        for (var j = 0; j < maxColumns; j++) {
          var cell = row[j];
          if (cell == null) break;
          if (i == 0 && j > 0) {
            languageList.add(cell.value.toString());
          }
          if (i > 0 && j == 0) {
            if (cell.value == null) {
              isFinish = true;
              break;
            }
            words.add(cell.value.toString());
          }
        }
        if (isFinish) {
          break;
        }
      }
    }

    T18InCtrl.to.translateStepDesc.value.add('开始组建Prompt');
    T18InCtrl.to.translateStepDesc.refresh();

    List<List<String?>?>? descList = [];
    if (KVCtrl.to.descCheckedLive.value) {
      var descMap = KVCtrl.to.descMapLive.value;
      descMap.forEach((key, value) {
        descList.add([key, value]);
      });
    }

    List<List<String?>?>? specialList = [];
    if (KVCtrl.to.specialCheckedLive.value) {
      var specialMap = KVCtrl.to.specialMapLive.value;
      specialMap.forEach((key, value) {
        specialList.add([key, value]);
      });
    }

    EXCEL.Sheet sheet1 = excel['Sheet1'];
    for (var i = 0; i < words.length; i++) {
      var word = words[i];
      var language = "";
      List<TranslateContent> list = [];
      for (var j = 0; j < languageList.length; j++) {
        var language = languageList[j];
        list.add(TranslateContent.fromParams(
          content: word,
          language: language,
          desc: descList,
          special: specialList,
        ));
      }

      T18InCtrl.to.translateStepDesc.value.add('[$word] - 国际化翻译进行中');
      T18InCtrl.to.translateStepDesc.refresh();

      T18Result result = await T18InCtrl.to.translateBatch(list);
      // print("[$word]:${result.toString()}");

      T18InCtrl.to.translateStepDesc.value.add('[$word] - 接收大模型反馈，开始解析结果');
      T18InCtrl.to.translateStepDesc.refresh();

      try {
        var resultStr = result.output?.text;
        if (resultStr != null) {
          if (resultStr.startsWith("```json")) {
            resultStr = resultStr.replaceFirst("```json", "");
          }
          if (resultStr.endsWith("```")) {
            resultStr = resultStr.substring(0, resultStr.length - 3);
          }

          print(resultStr);

          List<dynamic> list = jsonDecode(resultStr);
          List<Map<String, dynamic>> data = list.cast<Map<String, dynamic>>();

          for (var j = 0; j < languageList.length; j++) {
            var language = languageList[j];
            String rItem = "";
            for (var k = 0; k < data.length; k++) {
              var map = data[k];
              if (map.keys.contains(language)) {
                String content = map[language].toString();
                rItem = content;
                break;
              }
            }
            var cell = sheet1.cell(EXCEL.CellIndex.indexByColumnRow(
                columnIndex: j + 1, rowIndex: i + 1));
            cell.value = EXCEL.TextCellValue(rItem);
          }
          if (result.usage?.models != null &&
              result.usage!.models!.isNotEmpty) {
            tokens += ((result.usage!.models?[0]?.input_tokens ?? 0) +
                (result.usage!.models?[0]?.output_tokens ?? 0));
          }
        }

        T18InCtrl.to.translateStepDesc.value.add('[$word] - 解析完成,写入Excel');
        T18InCtrl.to.translateStepDesc.refresh();
      } catch (e) {
        print(e);
        T18InCtrl.to.translateStepDesc.value.add('[$word] - 解析失败，跳过该词条');
        T18InCtrl.to.translateStepDesc.refresh();
        continue;
      }
    }

    var fileBytes =
        excel.save(fileName: "C:/Users/shengk/Desktop/知识库/text.xlsx");
    print("Save file success! size= ${fileBytes?.length}");
    String newFilePath = T18InCtrl.to.filePathLive.value.replaceFirst(
        ".xlsx", "_${DateTime.now().microsecondsSinceEpoch}.xlsx");
    if (fileBytes != null && fileBytes.isNotEmpty) {
      File(newFilePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
    }

    Get.back();

    if (T18InCtrl.to.filePathLive.value.isNotEmpty) {
      _showTextDialog(
          Get.context!, "完成翻译，文件保存到：$newFilePath\n本次翻译花费token：$tokens");

      T18InCtrl.to.translateStepDesc.value
          .add("完成翻译，文件保存到：$newFilePath\n本次翻译花费token：$tokens");
      T18InCtrl.to.translateStepDesc.refresh();
      return;
    }
  }

  /**
   * 结果列表
   */
  Widget buildTextDisplay() {
    return Obx(() {
      var t18Result = T18InCtrl.to.t18Result.value;
      var state = T18InCtrl.to.translateState.value;
      Widget widget = Container();
      if (state == ConnectState.none) {
        widget = Win11TextDisplay(
          text: '竭诚为你服务！',
        );
      } else if (state == ConnectState.waiting) {
        widget = Win11TextDisplay(
          text: '正在翻译中...',
        );
      } else {
        var resultStr = t18Result.output?.text;
        if (resultStr != null) {
          if (resultStr.startsWith("```json")) {
            resultStr.replaceFirst("```json", "");
          }
          if (resultStr.endsWith("```")) {
            resultStr = resultStr.substring(0, resultStr.length - 3);
          }
          List<dynamic> list = jsonDecode(resultStr);
          List<Map<String, dynamic>> data = list.cast<Map<String, dynamic>>();

          if (data.isNotEmpty) {
            String content = data[0][_selectedOption].toString();
            widget = Win11TextDisplay(
              text: content,
            );
          }
        }
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: widget,
      );
    });
  }

  /**
   * 单条翻译
   */
  Widget buildTranslateBtn() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ElevatedButton(
        onPressed: () {
          String apikey = GSIntance.getInstance().getString(GSIntance.API_KEY);
          if (apikey.isEmpty) {
            _showTextDialog(Get.context!, "请先配置大模型Api Key!");
            return;
          }

          String content = _inputController.text;
          if (content.isEmpty) {
            return;
          }

          List<List<String?>?>? descList = [];
          if (KVCtrl.to.descCheckedLive.value) {
            var descMap = KVCtrl.to.descMapLive.value;
            descMap.forEach((key, value) {
              descList.add([key, value]);
            });
          }

          List<List<String?>?>? specialList = [];
          if (KVCtrl.to.specialCheckedLive.value) {
            var specialMap = KVCtrl.to.specialMapLive.value;
            specialMap.forEach((key, value) {
              specialList.add([key, value]);
            });
          }

          var encode = jsonEncode(content);
          TranslateContent translateContent = TranslateContent.fromParams(
            content: encode,
            language: _selectedOption,
            desc: descList,
            special: specialList,
          );
          List<TranslateContent> list = [];
          list.add(translateContent);
          T18InCtrl.to.translate(list);
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blue,
          // 按钮背景颜色
          textStyle: TextStyle(
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // 圆角
          ),
          elevation: 0,
          // 去掉阴影
          side: BorderSide(color: Colors.blue.shade200, width: 1.0),
          // 边框
          padding:
              EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0), // 内边距
        ),
        child: Text(
          '点击翻译',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }

  /**
   * 输入框
   */
  Widget buildInputContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
                color: Colors.white,
              ),
              child: TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: '请输入内容',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                ),
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 20.0),
          Container(
            width: 200.0,
            child: Win11DropdownButton(
              value: _selectedOption,
              items: _options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOption = newValue;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildApikeyContainer() {
    return Obx(() {
      String apiKey = T18InCtrl.to.apiKey.value;
      return Container(
        child: Row(
          children: [
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: _showTextInputDialog,
              child: Text(
                apiKey.isEmpty ? "请配置大模型Api Key" : "已完成配置",
                style: TextStyle(
                  color: apiKey.isEmpty ? Colors.white : Colors.blue,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: apiKey.isEmpty ? Colors.red : Colors.white,
              ),
            ),
            SizedBox(width: 20),
            buildDescCheckBox(),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => KVListPage(kvType: KVType.desc));
              },
              child: Text(
                "词汇说明",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(width: 20),
            buildSpecialCheckBox(),
            SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => KVListPage(kvType: KVType.special));
              },
              child: Text(
                "指定翻译",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildDescCheckBox() {
    return Obx(() {
      bool isChecked = KVCtrl.to.descCheckedLive.value;
      return Row(
        children: [
          Checkbox(
            value: isChecked,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: BorderSide(color: Colors.grey.shade400, width: 1.0),
            fillColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.blue; // 选中时的颜色
                }
                return null; // 未选中时的颜色
              },
            ),
            onChanged: (bool? value) {
              KVCtrl.to.descCheckedLive.value = value ?? false;
              KVCtrl.to.descCheckedLive.refresh();
            },
          ),
          Container(
            child: Text(
              isChecked ? '已启用' : '未启用',
              style: TextStyle(
                color: isChecked ? Colors.blue : Colors.grey.shade400,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildSpecialCheckBox() {
    return Obx(() {
      bool isChecked = KVCtrl.to.specialCheckedLive.value;
      return Row(
        children: [
          Checkbox(
            value: isChecked,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            side: BorderSide(color: Colors.grey.shade400, width: 1.0),
            fillColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.blue; // 选中时的颜色
                }
                return null; // 未选中时的颜色
              },
            ),
            onChanged: (bool? value) {
              KVCtrl.to.specialCheckedLive.value = value ?? false;
              KVCtrl.to.specialCheckedLive.refresh();
            },
          ),
          Container(
            child: Text(
              isChecked ? '已启用' : '未启用',
              style: TextStyle(
                color: isChecked ? Colors.blue : Colors.grey.shade400,
              ),
            ),
          ),
        ],
      );
    });
  }

  void _showTextInputDialog() async {
    final TextEditingController _controller = TextEditingController();

    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0), // 设置圆角
        ),
        title: Text("API Key", style: TextStyle(fontSize: 18.0)),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: "通义千问大模型API Key",
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("取消"),
            onPressed: () {
              Get.back(); // 关闭对话框
            },
          ),
          TextButton(
            child: Text("确定"),
            onPressed: () {
              Get.back(result: _controller.text); // 关闭对话框
            },
          ),
        ],
      ),
      barrierDismissible: true, // 允许点击外部关闭
    ).then((input) {
      if (input == null) return;
      GSIntance.getInstance().setString(GSIntance.API_KEY, input);
      T18InCtrl.to.checkApiKey();
    });
  }

  Future<void> _downloadFile() async {
    _isDownloading = true;
    _downloadMessage = '请选择一个保存路径';

    try {
      // 让用户选择保存位置
      final String? directoryPath = await getDirectoryPath();

      if (directoryPath == null) {
        _isDownloading = false;
        _downloadMessage = '保存失败';
        _showTextDialog(Get.context!, _downloadMessage);
        return;
      }

      // 获取 assets 目录中的文件
      ByteData data =
          await DefaultAssetBundle.of(context).load('assets/template.xlsx');

      // 保存文件
      File file = File('$directoryPath/template.xlsx');
      await file.writeAsBytes(data.buffer.asUint8List());

      _isDownloading = false;
      _downloadMessage = '模板文件已经保存到 $directoryPath\\template.xlsx!';
      _showTextDialog(Get.context!, _downloadMessage);
    } catch (e) {
      _isDownloading = false;
      _downloadMessage = '保存失败: $e';
      _showTextDialog(Get.context!, _downloadMessage);
    }
  }
}
