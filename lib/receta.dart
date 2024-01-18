class Receta {
  final String tipo;
  final String dificultad;
  final String nombre;
  final String? ingredientes;
  final int calorias;
  final String? pasos;
  final String tiempo;
  final String elaboracion;
  final String imagen;

  Receta(
      {required this.tipo,
      required this.dificultad,
      required this.nombre,
      required this.ingredientes,
      required this.calorias,
      required this.pasos,
      required this.tiempo,
      required this.elaboracion,
      required this.imagen});
}
