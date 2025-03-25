import 'package:yconic/domain/entities/Persona.dart';
import 'package:yconic/domain/repositories/Persona_repository.dart';

class GetPersonaByIdUsecase {
  final PersonaRepository repository;

  GetPersonaByIdUsecase(this.repository);

  Future<Persona> execute(String id) async {
    return await repository.getPersonaById(id);
  }
}
