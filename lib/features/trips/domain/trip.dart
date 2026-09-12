import 'package:hive_ce/hive.dart';
part 'trip.g.dart';

@HiveType(typeId: 0)
class Trip {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String destination;
  @HiveField(2)
  final DateTime startDate;
  @HiveField(3)
  final DateTime endDate;
  @HiveField(4)
  final int travelers;
  @HiveField(5)
  final String? country;
  @HiveField(6)
  final double? latitude;
  @HiveField(7)
  final double? longitude;
  @HiveField(8)
  final double? budgetTotal;
  @HiveField(9)
  final bool? isSavedOffline;
  @HiveField(10)
  final DateTime? createdAt;
  @HiveField(11)
  final String? status;
  @HiveField(12)
  final String? tripImg;

  const Trip({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.travelers,
    this.country,
    this.latitude,
    this.longitude,
    this.budgetTotal,
    this.isSavedOffline,
    this.createdAt,
    this.status,
    this.tripImg
  });

  factory Trip.fromJson(Map<String, dynamic>json){
    return Trip(
      id : json['id'] as String,
      destination: json['destination'] as String,
      startDate:  DateTime.parse(json['startDate'] as String),
      endDate:  DateTime.parse(json['endDate'] as String),
      travelers: json['travelers'] as int,
      country: json['country'] as String?,
      latitude: (json ['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      budgetTotal: (json['budgetTotal'] as num?)?.toDouble(),
      isSavedOffline: json['isSavedOffline'] as bool? ?? false,
      createdAt:json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String?,
      tripImg: json['tripImg'] as String?,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'destination' : destination,
      'startDate' : startDate.toIso8601String(),
      'endDate' : endDate.toIso8601String(),
      'travelers': travelers,
      'country' : country,
      'latitude' : latitude,
      'longitude' : longitude,
      'budgetTotal': budgetTotal,
      'isSavedOffline': isSavedOffline,
      'createdAt' : createdAt?.toIso8601String() ,
      'status': status,
      'tripImg': tripImg,
    };
  }



  Trip copyWith({
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    int? travelers,
    String? country,
    double? latitude,
    double? longitude,
    double? budgetTotal,
    bool? isSavedOffline,
    DateTime? createdAt,
    String? status,
    String? tripImg,
  }) {
    return Trip(
      id: id,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      travelers: travelers ?? this.travelers,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      budgetTotal: budgetTotal ?? this.budgetTotal,
      isSavedOffline: isSavedOffline ?? this.isSavedOffline,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      tripImg: tripImg?? this.tripImg,
    );
  }



  @override
  String toString(){
    return'Trip(id:$id, destination:$destination,  startDate: $startDate, endDate: $endDate, travelers: $travelers, country: $country, latitude: $latitude, longitude: $longitude, budgetTotal: $budgetTotal, isSavedOffline: $isSavedOffline,createdAt: $createdAt, status: $status )';
  }

}




class TripPage {
  final List<Trip> trips;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;

  const TripPage({
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.trips
  });


  factory TripPage.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] as Map<String, dynamic>;

    return TripPage(
      trips: (json['data'] as List).map((item) => Trip.fromJson(item as Map<String, dynamic>)).toList(),
      page: pagination['page'] as int,
      pageSize: pagination['pageSize'] as int,
      totalCount: pagination['totalCount'] as int,
      totalPages: pagination['totalPages'] as int,
    );
  }

}


