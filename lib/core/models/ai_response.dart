class AiResponse {
  AiResponse({
    required this.candidates,
    required this.usageMetadata,
    required this.modelVersion,
    required this.responseId,
  });
  late final List<Candidates> candidates;
  late final UsageMetadata usageMetadata;
  late final String modelVersion;
  late final String responseId;
  
  AiResponse.fromJson(Map<String, dynamic> json){
    candidates = List.from(json['candidates']).map((e)=>Candidates.fromJson(e)).toList();
    usageMetadata = UsageMetadata.fromJson(json['usageMetadata']);
    modelVersion = json['modelVersion'];
    responseId = json['responseId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['candidates'] = candidates.map((e)=>e.toJson()).toList();
    _data['usageMetadata'] = usageMetadata.toJson();
    _data['modelVersion'] = modelVersion;
    _data['responseId'] = responseId;
    return _data;
  }
}

class Candidates {
  Candidates({
    required this.content,
    required this.finishReason,
    required this.index,
  });
  late final Content content;
  late final String finishReason;
  late final int index;
  
  Candidates.fromJson(Map<String, dynamic> json){
    content = Content.fromJson(json['content']);
    finishReason = json['finishReason'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['content'] = content.toJson();
    _data['finishReason'] = finishReason;
    _data['index'] = index;
    return _data;
  }
}

class Content {
  Content({
    required this.parts,
    required this.role,
  });
  late final List<Parts> parts;
  late final String role;
  
  Content.fromJson(Map<String, dynamic> json){
    parts = List.from(json['parts']).map((e)=>Parts.fromJson(e)).toList();
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['parts'] = parts.map((e)=>e.toJson()).toList();
    _data['role'] = role;
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

class UsageMetadata {
  UsageMetadata({
    required this.promptTokenCount,
    required this.candidatesTokenCount,
    required this.totalTokenCount,
    required this.promptTokensDetails,
    required this.thoughtsTokenCount,
  });
  late final int promptTokenCount;
  late final int candidatesTokenCount;
  late final int totalTokenCount;
  late final List<PromptTokensDetails> promptTokensDetails;
  late final int thoughtsTokenCount;
  
  UsageMetadata.fromJson(Map<String, dynamic> json){
    promptTokenCount = json['promptTokenCount'];
    candidatesTokenCount = json['candidatesTokenCount'];
    totalTokenCount = json['totalTokenCount'];
    promptTokensDetails = List.from(json['promptTokensDetails']).map((e)=>PromptTokensDetails.fromJson(e)).toList();
    thoughtsTokenCount = json['thoughtsTokenCount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['promptTokenCount'] = promptTokenCount;
    _data['candidatesTokenCount'] = candidatesTokenCount;
    _data['totalTokenCount'] = totalTokenCount;
    _data['promptTokensDetails'] = promptTokensDetails.map((e)=>e.toJson()).toList();
    _data['thoughtsTokenCount'] = thoughtsTokenCount;
    return _data;
  }
}

class PromptTokensDetails {
  PromptTokensDetails({
    required this.modality,
    required this.tokenCount,
  });
  late final String modality;
  late final int tokenCount;
  
  PromptTokensDetails.fromJson(Map<String, dynamic> json){
    modality = json['modality'];
    tokenCount = json['tokenCount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['modality'] = modality;
    _data['tokenCount'] = tokenCount;
    return _data;
  }
}