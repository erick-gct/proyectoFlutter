class Registros {
  int? id;
  String? nombre;
  String? dia_ingreso;
  String? hora_entrada;
  String? hora_salida;
  String? hora_comida;
  String? observaciones;

  Registros(
      {this.id,
      this.nombre,
      this.dia_ingreso,
      this.hora_entrada,
      this.hora_salida,
      this.hora_comida,
      this.observaciones});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'dia_ingreso': dia_ingreso,
      'hora_entrada': hora_entrada,
      'hora_salida': hora_salida,
      'hora_comida': hora_comida,
      'observaciones': observaciones
    };
  }
}
