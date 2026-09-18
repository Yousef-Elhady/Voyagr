class HotelModel {
  final String imageUrl;
  final String name;
  final String location;
  final double distanceFromCenter;
  final String distanceUnit;
  final int starRating;
  final double reviewScore;
  final String reviewLabel;
  final bool isTopChoice;
  final bool isFavorite;
  final bool hasFreeWifi;
  final bool hasPool;
  final bool hasSpa;

  HotelModel({
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.distanceFromCenter,
    required this.distanceUnit,
    required this.starRating,
    required this.reviewScore,
    required this.reviewLabel,
    required this.isTopChoice,
    required this.isFavorite,
    required this.hasFreeWifi,
    required this.hasPool,
    required this.hasSpa,
  });

  // From JSON
  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      imageUrl: json['imageUrl'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      distanceFromCenter: (json['distanceFromCenter'] as num).toDouble(),
      distanceUnit: json['distanceUnit'] as String,
      starRating: json['starRating'] as int,
      reviewScore: (json['reviewScore'] as num).toDouble(),
      reviewLabel: json['reviewLabel'] as String,
      isTopChoice: json['isTopChoice'] as bool,
      isFavorite: json['isFavorite'] as bool,
      hasFreeWifi: json['hasFreeWifi'] as bool,
      hasPool: json['hasPool'] as bool,
      hasSpa: json['hasSpa'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'location': location,
      'distanceFromCenter': distanceFromCenter,
      'distanceUnit': distanceUnit,
      'starRating': starRating,
      'reviewScore': reviewScore,
      'reviewLabel': reviewLabel,
      'isTopChoice': isTopChoice,
      'isFavorite': isFavorite,
      'hasFreeWifi': hasFreeWifi,
      'hasPool': hasPool,
      'hasSpa': hasSpa,
    };
  }
}

final List<HotelModel> dummyHotels = [
  HotelModel(
    imageUrl:
        'lib/features/explore/presentation/widgets/hotelTab/DummyPhoto.png',
    name: 'The Aman Tokyo',
    location: 'Chiyoda City',
    distanceFromCenter: 0.4,
    distanceUnit: 'miles',
    starRating: 5,
    reviewScore: 9.8,
    reviewLabel: 'EXCEPTIONAL',
    isTopChoice: true,
    isFavorite: false,
    hasFreeWifi: true,
    hasPool: true,
    hasSpa: true,
  ),

  HotelModel(
    imageUrl:
        'lib/features/explore/presentation/widgets/hotelTab/DummyPhoto.png',
    name: 'Park Hyatt Tokyo',
    location: 'Shinjuku City',
    distanceFromCenter: 1.2,
    distanceUnit: 'miles',
    starRating: 5,
    reviewScore: 9.4,
    reviewLabel: 'WONDERFUL',
    isTopChoice: true,
    isFavorite: true,
    hasFreeWifi: true,
    hasPool: true,
    hasSpa: true,
  ),

  HotelModel(
    imageUrl:
        'lib/features/explore/presentation/widgets/hotelTab/DummyPhoto.png',
    name: 'Shibuya Grand Hotel',
    location: 'Shibuya City',
    distanceFromCenter: 1.8,
    distanceUnit: 'miles',
    starRating: 4,
    reviewScore: 9.1,
    reviewLabel: 'EXCELLENT',
    isTopChoice: false,
    isFavorite: false,
    hasFreeWifi: true,
    hasPool: false,
    hasSpa: true,
  ),

  HotelModel(
    imageUrl:
        'lib/features/explore/presentation/widgets/hotelTab/DummyPhoto.png',
    name: 'Tokyo Bay Resort',
    location: 'Minato City',
    distanceFromCenter: 2.3,
    distanceUnit: 'miles',
    starRating: 4,
    reviewScore: 8.7,
    reviewLabel: 'VERY GOOD',
    isTopChoice: false,
    isFavorite: true,
    hasFreeWifi: true,
    hasPool: true,
    hasSpa: false,
  ),

  HotelModel(
    imageUrl:
        'lib/features/explore/presentation/widgets/hotelTab/DummyPhoto.png',
    name: 'Imperial Tokyo Hotel',
    location: 'Chiyoda City',
    distanceFromCenter: 0.8,
    distanceUnit: 'miles',
    starRating: 5,
    reviewScore: 9.6,
    reviewLabel: 'EXCEPTIONAL',
    isTopChoice: true,
    isFavorite: false,
    hasFreeWifi: true,
    hasPool: true,
    hasSpa: true,
  ),

  HotelModel(
    imageUrl:
        'lib/features/explore/presentation/widgets/hotelTab/DummyPhoto.png',
    name: 'Shinjuku City Hotel',
    location: 'Shinjuku City',
    distanceFromCenter: 1.5,
    distanceUnit: 'miles',
    starRating: 3,
    reviewScore: 8.2,
    reviewLabel: 'VERY GOOD',
    isTopChoice: false,
    isFavorite: false,
    hasFreeWifi: true,
    hasPool: false,
    hasSpa: false,
  ),
];
