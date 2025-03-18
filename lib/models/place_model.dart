class Place {
  final String displayName;
  final double lat;
  final double lng;
  final String formattedAddress;

  Place({
    required this.displayName,
    required this.lat,
    required this.lng,
    required this.formattedAddress,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    return Place(
      displayName:
          json['displayName'] != null ? json['displayName']['text'] ?? '' : '',
      lat: location['latitude'],
      lng: location['longitude'],
      formattedAddress: json['formattedAddress'] ?? '',
    );
  }
}
