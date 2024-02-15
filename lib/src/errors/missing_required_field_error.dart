class MissingRequiredFieldError extends Error {
  final String fieldName;

  MissingRequiredFieldError(this.fieldName);

  @override
  String toString() {
    return 'Missing required field: $fieldName';
  }
}
