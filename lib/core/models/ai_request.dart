class AiRequest {
  AiRequest({
    required this.systemInstruction,
    required this.contents,
  });
  late final SystemInstruction systemInstruction;
  late final List<Contents> contents;
  
  AiRequest.fromJson(Map<String, dynamic> json){
    systemInstruction = SystemInstruction.fromJson(json['system_instruction']);
    contents = List.from(json['contents']).map((e)=>Contents.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['system_instruction'] = systemInstruction.toJson();
    _data['contents'] = contents.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class SystemInstruction {
  SystemInstruction({
    required this.parts,
  });
  late final List<Parts> parts;
  
  SystemInstruction.fromJson(Map<String, dynamic> json){
    parts = List.from(json['parts']).map((e)=>Parts.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['parts'] = parts.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Parts {
  Parts({
    required this.text,
  });
  late final String text;
  
  Parts.fromJson(Map<String, dynamic> json){
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['text'] = text;
    return _data;
  }
}

class Contents {
  Contents({
    required this.parts,
  });
  late final List<Parts> parts;
  
  Contents.fromJson(Map<String, dynamic> json){
    parts = List.from(json['parts']).map((e)=>Parts.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['parts'] = parts.map((e)=>e.toJson()).toList();
    return _data;
  }
}