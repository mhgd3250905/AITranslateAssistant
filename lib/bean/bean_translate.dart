import 'dart:convert' show json;

class TranslateResult {

  String? result;

  TranslateResult.fromParams({this.result});

  factory TranslateResult(Object jsonStr) => jsonStr is String ? TranslateResult.fromJson(json.decode(jsonStr)) : TranslateResult.fromJson(jsonStr);

  static TranslateResult? parse(jsonStr) => ['null', '', null].contains(jsonStr) ? null : TranslateResult(jsonStr);

  TranslateResult.fromJson(jsonRes) {
    result = jsonRes['result'];
  }

  @override
  String toString() {
    return '{"result": ${result != null?'${json.encode(result)}':'null'}}';
  }

  String toJson() => this.toString();
}