class Output {
  final String id, output, status;
  final dynamic error;

  Output({
    required this.id,
    required this.output,
    required this.status,
    required this.error,
  });

  factory Output.fromJson(Map<String, dynamic> json) {
    return Output(
        id: (json['id'] == null ? "" : json['id']) as String,
        output: (json['output'] == null ? "" : json['output']) as String,
        status: (json['status'] == null ? "" : json['status']) as String,
        error: json['error'] as dynamic);
  }
}
