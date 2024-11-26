import 'dart:convert' show json;

class TranslateContent {

  String? content;
  String? language;
  List<List<String?>?>? desc;
  List<List<String?>?>? special;

  TranslateContent.fromParams({this.content, this.language, this.desc, this.special});

  factory TranslateContent(Object jsonStr) => jsonStr is String ? TranslateContent.fromJson(json.decode(jsonStr)) : TranslateContent.fromJson(jsonStr);

  static TranslateContent? parse(jsonStr) => ['null', '', null].contains(jsonStr) ? null : TranslateContent(jsonStr);

  TranslateContent.fromJson(jsonRes) {
    content = jsonRes['content'];
    language = jsonRes['language'];
    desc = jsonRes['desc'] == null ? null : [];

    for (var descItem in desc == null ? [] : jsonRes['desc']){
      List<String?>? descChild = descItem == null ? null : [];
      for (var descItemItem in descChild == null ? [] : descItem){
        descChild!.add(descItemItem);
      }
      desc!.add(descChild);
    }

    special = jsonRes['special'] == null ? null : [];

    for (var specialItem in special == null ? [] : jsonRes['special']){
      List<String?>? specialChild = specialItem == null ? null : [];
      for (var specialItemItem in specialChild == null ? [] : specialItem){
        specialChild!.add(specialItemItem);
      }
      special!.add(specialChild);
    }
  }

  @override
  String toString() {
    return '{"content": ${content != null?'${json.encode(content)}':'null'}, "language": ${language != null?'${json.encode(language)}':'null'}, "desc": ${desc != null?'${json.encode(desc)}':'null'}, "special": ${special != null?'${json.encode(special)}':'null'}}';
  }

  String toJson() => this.toString();
}