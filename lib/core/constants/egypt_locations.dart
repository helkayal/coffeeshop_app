class EgyptLocations {
  static const Map<String, List<String>> locations = {
    'locations.states.cairo': [
      'locations.cities.cairo',
      'locations.cities.new_cairo',
      'locations.cities.nasr_city',
      'locations.cities.maadi',
    ],
    'locations.states.giza': [
      'locations.cities.giza',
      'locations.cities.october_6',
      'locations.cities.zayed',
    ],
    'locations.states.alexandria': [
      'locations.cities.alexandria',
      'locations.cities.burj_al_arab',
    ],
    'locations.states.dakahlia': [
      'locations.cities.mansoura',
      'locations.cities.talkha',
    ],
    'locations.states.red_sea': [
      'locations.cities.hurghada',
      'locations.cities.gouna',
    ],
  };

  static List<String> get states => locations.keys.toList();

  static List<String> getCitiesForState(String stateKey) {
    return locations[stateKey] ?? [];
  }
}
