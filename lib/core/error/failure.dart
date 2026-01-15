abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.statusCode
  });
}

class NerworkFailure extends Failure {
  const NerworkFailure({
    required super.message,
    super.statusCode
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.statusCode
  });
}
