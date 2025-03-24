import 'package:yconic/domain/entities/Persona.dart';

abstract class PersonaRepository {
  Future<Persona> getPersonaById(String id);
  Future<Persona> updatePersona(Persona persona);
}
