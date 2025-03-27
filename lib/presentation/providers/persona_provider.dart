import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/domain/entities/persona.dart';
import 'package:yconic/presentation/providers/user/user_provider.dart';

final personaProvider = Provider<Persona?>((ref) {
  final user = ref.watch(userProvider);
  return user?.UserPersona;
});
