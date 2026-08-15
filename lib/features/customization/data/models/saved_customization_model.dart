import '../../domain/entities/saved_customization.dart';

class SavedCustomizationModel extends SavedCustomization {
  const SavedCustomizationModel({
    required super.pickedOptionIds,
    required super.toggledOptionIds,
  });

  factory SavedCustomizationModel.fromStorage(Map<String, dynamic> data) {
    final rawPicked = data['picked'];
    final rawToggled = data['toggled'];
    return SavedCustomizationModel(
      pickedOptionIds: rawPicked is Map
          ? rawPicked.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            )
          : const {},
      toggledOptionIds: rawToggled is Map
          ? rawToggled.map(
              (key, value) => MapEntry(
                key.toString(),
                value is List
                    ? value.map((item) => item.toString()).toList()
                    : const <String>[],
              ),
            )
          : const {},
    );
  }

  factory SavedCustomizationModel.fromEntity(SavedCustomization entity) =>
      SavedCustomizationModel(
        pickedOptionIds: entity.pickedOptionIds,
        toggledOptionIds: entity.toggledOptionIds,
      );

  Map<String, dynamic> toStorage() => {
    'picked': pickedOptionIds,
    'toggled': toggledOptionIds,
  };
}
