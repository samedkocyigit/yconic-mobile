import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yconic/core/services/token_service.dart';

final tokenServiceProvider = Provider<TokenService>((ref) => TokenService());
