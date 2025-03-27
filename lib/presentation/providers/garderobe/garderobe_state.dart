import 'package:yconic/domain/entities/garderobe.dart';

class GarderobeState {
  final bool isLoading;
  final Garderobe? garderobe;
  final String? error;

  GarderobeState({this.isLoading = false, this.garderobe, this.error});

  GarderobeState copyWith({
    bool? isLoading,
    Garderobe? garderobe,
    String? error,
  }) {
    return GarderobeState(
      isLoading: isLoading ?? this.isLoading,
      garderobe: garderobe ?? this.garderobe,
      error: error,
    );
  }

  factory GarderobeState.initial() {
    return GarderobeState(isLoading: false, error: null, garderobe: null);
  }
}
