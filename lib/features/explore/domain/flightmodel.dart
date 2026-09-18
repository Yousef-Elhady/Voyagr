class FlightModel {
  final String id;

  final String airlineName;
  final String? airlineLogo;

  final bool isEcoFriendly;
  final bool isRecommended;

  final String departureTime;
  final String arrivalTime;

  final String departureAirport;
  final String arrivalAirport;

  final String duration;

  final int stops;
  final String? stopAirport;

  final double price;
  final String currency;

  const FlightModel({
    required this.id,
    required this.airlineName,
    this.airlineLogo,
    required this.isEcoFriendly,
    required this.isRecommended,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.duration,
    required this.stops,
    this.stopAirport,
    required this.price,
    required this.currency,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'] as String,
      airlineName: json['airlineName'] as String,
      airlineLogo: json['airlineLogo'] as String?,
      isEcoFriendly: json['isEcoFriendly'] as bool? ?? false,
      isRecommended: json['isRecommended'] as bool? ?? false,
      departureTime: json['departureTime'] as String,
      arrivalTime: json['arrivalTime'] as String,
      departureAirport: json['departureAirport'] as String,
      arrivalAirport: json['arrivalAirport'] as String,
      duration: json['duration'] as String,
      stops: json['stops'] as int,
      stopAirport: json['stopAirport'] as String?,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
    );
  }
}

final List<FlightModel> dummyFlights = [
  FlightModel(
    id: '1',
    airlineName: 'EgyptAir',
    airlineLogo: 'https://example.com/egyptair.png',
    isEcoFriendly: true,
    isRecommended: true,
    departureTime: '08:30',
    arrivalTime: '11:45',
    departureAirport: 'CAI',
    arrivalAirport: 'DXB',
    duration: '3h 15m',
    stops: 0,
    stopAirport: null,
    price: 8500.0,
    currency: 'EGP',
  ),

  FlightModel(
    id: '2',
    airlineName: 'Emirates',
    airlineLogo: 'https://example.com/emirates.png',
    isEcoFriendly: false,
    isRecommended: true,
    departureTime: '14:20',
    arrivalTime: '19:35',
    departureAirport: 'CAI',
    arrivalAirport: 'DXB',
    duration: '5h 15m',
    stops: 0,
    stopAirport: null,
    price: 12500.0,
    currency: 'EGP',
  ),

  FlightModel(
    id: '3',
    airlineName: 'Qatar Airways',
    airlineLogo: 'https://example.com/qatar.png',
    isEcoFriendly: true,
    isRecommended: false,
    departureTime: '16:45',
    arrivalTime: '00:30',
    departureAirport: 'CAI',
    arrivalAirport: 'DOH',
    duration: '6h 45m',
    stops: 1,
    stopAirport: 'DOH',
    price: 9800.0,
    currency: 'EGP',
  ),

  FlightModel(
    id: '4',
    airlineName: 'Turkish Airlines',
    airlineLogo: 'https://example.com/turkish.png',
    isEcoFriendly: false,
    isRecommended: false,
    departureTime: '10:15',
    arrivalTime: '18:40',
    departureAirport: 'CAI',
    arrivalAirport: 'IST',
    duration: '8h 25m',
    stops: 1,
    stopAirport: 'ATH',
    price: 7200.0,
    currency: 'EGP',
  ),

  FlightModel(
    id: '5',
    airlineName: 'Lufthansa',
    airlineLogo: null,
    isEcoFriendly: true,
    isRecommended: false,
    departureTime: '09:00',
    arrivalTime: '16:20',
    departureAirport: 'CAI',
    arrivalAirport: 'FRA',
    duration: '7h 20m',
    stops: 0,
    stopAirport: null,
    price: 11000.0,
    currency: 'EGP',
  ),

  FlightModel(
    id: '6',
    airlineName: 'Air France',
    airlineLogo: null,
    isEcoFriendly: false,
    isRecommended: true,
    departureTime: '21:10',
    arrivalTime: '05:55',
    departureAirport: 'CAI',
    arrivalAirport: 'CDG',
    duration: '8h 45m',
    stops: 1,
    stopAirport: 'FCO',
    price: 10500.0,
    currency: 'EGP',
  ),
];
