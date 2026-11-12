/// Error de validación asociado a un campo del formulario.
class ValidacionException implements Exception {
  ValidacionException(this.campo, this.codigo);

  /// Campo afectado, por ejemplo `monto`.
  final String campo;

  /// Código del error, por ejemplo `requerido` o `mayorACero`.
  final String codigo;

  @override
  String toString() => 'ValidacionException($campo, $codigo)';
}
