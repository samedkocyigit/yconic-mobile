import 'package:yconic/domain/entities/persona.dart';
import 'package:yconic/domain/repositories/persona_repository.dart';

class UpdatePersonaUsecase {
  final PersonaRepository repository;

  UpdatePersonaUsecase(this.repository);

  Future<Persona> execute(Persona persona) async {
    return await repository.updatePersona(persona);
  }
}
