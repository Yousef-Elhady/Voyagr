class Trip {

  final String id;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final int travelers;
  final String? country;
  final double? latitude;
  final double? longitude;
  final double? budgetTotal;
  final bool? isSavedOffline;
  final DateTime? createdAt;
  final String? status;

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
      isSavedOffline: json['isSavedOffline'] as bool?,
      createdAt:json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String?
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


