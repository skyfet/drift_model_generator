class NonNullableFieldIsAllowedNull implements Exception {
  final String fieldName;

  NonNullableFieldIsAllowedNull(this.fieldName);

  @override
  String toString() {
    return 'Field "$fieldName" is not nullable, but null value is allowed.';
  }
}
