class DestinationModel {
  final String id;

  // Destination information
  final String destination;
  final String? country;

  // Destination card information
  final String? badge;
  final String? imageUrl;
  final double? priceFrom;

  // Trip information
  final DateTime startDate;
  final DateTime endDate;
  final int travelers;
  final double? budgetTotal;
  final bool? isSavedOffline;
  final DateTime? createdAt;
  final String? status;

  // Location
  final double? latitude;
  final double? longitude;

  // Weather
  final double? temperature;
  final String? weatherCondition;

  const DestinationModel({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.travelers,

    this.country,
    this.badge,
    this.imageUrl,
    this.priceFrom,
    this.budgetTotal,
    this.isSavedOffline,
    this.createdAt,
    this.status,
    this.latitude,
    this.longitude,
    this.temperature,
    this.weatherCondition,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'] as String,

      destination: json['destination'] as String,
      country: json['country'] as String?,

      badge: json['badge'] as String?,
      imageUrl: json['imageUrl'] as String,
      priceFrom: (json['priceFrom'] as num?)?.toDouble(),

      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      travelers: json['travelers'] as int,

      budgetTotal: (json['budgetTotal'] as num?)?.toDouble(),
      isSavedOffline: json['isSavedOffline'] as bool? ?? false,

      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),

      status: json['status'] as String?,

      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),

      temperature: (json['temperature'] as num?)?.toDouble(),
      weatherCondition: json['weatherCondition'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destination': destination,
      'country': country,

      'badge': badge,
      'imageUrl': imageUrl,
      'priceFrom': priceFrom,

      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'travelers': travelers,

      'budgetTotal': budgetTotal,
      'isSavedOffline': isSavedOffline,
      'createdAt': createdAt?.toIso8601String(),
      'status': status,

      'latitude': latitude,
      'longitude': longitude,

      'temperature': temperature,
      'weatherCondition': weatherCondition,
    };
  }
}
