class UpdateUserAccountDto {
  final String? phoneNumber;
  final DateTime? birthday;
  final double? weight;
  final double? height;
  final int? personaType;

  UpdateUserAccountDto(
      {this.phoneNumber,
      this.birthday,
      this.weight,
      this.height,
      this.personaType});

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'birthday': birthday?.toIso8601String(),
      'weight': weight,
      'height': height,
      'personaType': personaType,
    };
  }
}
