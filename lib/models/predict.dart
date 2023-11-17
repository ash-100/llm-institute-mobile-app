class Predict {
  final String id, model, version, prompt, status, created_at;
  final int max_new_tokens;
  final String cancel_url, get_url;
  final dynamic error;

  Predict({
    required this.id,
    required this.model,
    required this.version,
    required this.max_new_tokens,
    required this.prompt,
    required this.status,
    required this.created_at,
    required this.cancel_url,
    required this.get_url,
    required this.error,
  });

  factory Predict.fromJson(Map<String, dynamic> json) {
    return Predict(
      id: json['id'] as String,
      model: json['model'] as String,
      version: json['version'] as String,
      max_new_tokens: json['input']['max_new_tokens'] as int,
      prompt: json['input']['prompt'] as String,
      status: json['status'] as String,
      created_at: json['created_at'] as String,
      cancel_url: json['urls']['cancel'] as String,
      get_url: json['urls']['get'] as String,
      error: json['error'] as dynamic,
    );
  }
}
