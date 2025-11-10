class Result<T> {
  const Result._({this.data, this.error});

  final T? data;
  final Object? error;

  bool get isOk => error == null;
  bool get isErr => error != null;

  factory Result.ok([T? data]) => Result._(data: data);
  factory Result.err(Object error) => Result._(error: error);
}
