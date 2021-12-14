class Banda {
  String id;
  String nombre;
  int votos;

  Banda({
    required this.id,
    required this.nombre,
    required this.votos,
  });

  factory Banda.fromMap(Map<String, dynamic> obj) => Banda(
        //recibe un mapa y devuelve una instancia de la clase
        id: obj.containsKey('id') ? obj['id'] : 'no-id',
        nombre: obj.containsKey('nombre') ? obj['nombre'] : 'no-name',
        votos: obj.containsKey('votos') ? obj['votos'] : 0,
      );
}
