import 'package:yconic/domain/entities/persona.dart';

abstract class PersonaRepository {
  Future<Persona> getPersonaById(String id);
  Future<Persona> updatePersona(Persona persona);
}
