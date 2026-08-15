class SavedCustomization {
  final Map<String, String> pickedOptionIds;
  final Map<String, List<String>> toggledOptionIds;

  const SavedCustomization({
    this.pickedOptionIds = const {},
    this.toggledOptionIds = const {},
  });
}
