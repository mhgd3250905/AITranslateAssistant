import 'dart:convert' show json;

class T18Result {

  String? request_id;
  Output? output;
  Usage? usage;

  T18Result.fromParams({this.request_id, this.output, this.usage});

  factory T18Result(Object jsonStr) => jsonStr is String ? T18Result.fromJson(json.decode(jsonStr)) : T18Result.fromJson(jsonStr);

  static T18Result? parse(jsonStr) => ['null', '', null].contains(jsonStr) ? null : T18Result(jsonStr);

  T18Result.fromJson(jsonRes) {
    request_id = jsonRes['request_id'];
    output = jsonRes['output'] == null ? null : Output.fromJson(jsonRes['output']);
    usage = jsonRes['usage'] == null ? null : Usage.fromJson(jsonRes['usage']);
  }

  @override
  String toString() {
    return '{"request_id": ${request_id != null?'${json.encode(request_id)}':'null'}, "output": $output, "usage": $usage}';
  }

  String toJson() => this.toString();
}

class Usage {

  List<Tokens?>? models;

  Usage.fromParams({this.models});

  Usage.fromJson(jsonRes) {
    models = jsonRes['models'] == null ? null : [];

    for (var modelsItem in models == null ? [] : jsonRes['models']){
      models!.add(modelsItem == null ? null : Tokens.fromJson(modelsItem));
    }
  }

  @override
  String toString() {
    return '{"models": $models}';
  }

  String toJson() => this.toString();
}

class Tokens {

  int? input_tokens;
  int? output_tokens;
  String? model_id;

  Tokens.fromParams({this.input_tokens, this.output_tokens, this.model_id});

  Tokens.fromJson(jsonRes) {
    input_tokens = jsonRes['input_tokens'];
    output_tokens = jsonRes['output_tokens'];
    model_id = jsonRes['model_id'];
  }

  @override
  String toString() {
    return '{"input_tokens": $input_tokens, "output_tokens": $output_tokens, "model_id": ${model_id != null?'${json.encode(model_id)}':'null'}}';
  }

  String toJson() => this.toString();
}

class Output {

  String? finish_reason;
  String? session_id;
  String? text;

  Output.fromParams({this.finish_reason, this.session_id, this.text});

  Output.fromJson(jsonRes) {
    finish_reason = jsonRes['finish_reason'];
    session_id = jsonRes['session_id'];
    text = jsonRes['text'];
  }

  @override
  String toString() {
    return '{"finish_reason": ${finish_reason != null?'${json.encode(finish_reason)}':'null'}, "session_id": ${session_id != null?'${json.encode(session_id)}':'null'}, "text": ${text != null?'${json.encode(text)}':'null'}}';
  }

  String toJson() => this.toString();
}