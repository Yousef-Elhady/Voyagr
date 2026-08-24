class User{
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String? preferredCurrency;
  final String? units;


  const User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.preferredCurrency,
    this.units,

  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        profileImage: json['profileImage'] as String?,
        preferredCurrency: json['preferredCurrency'] as String?,
        units: json['units'] as String?,

    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'preferredCurrency': preferredCurrency,
      'units': units,

    };
  }



  //needed for update later on.
  User copyWith({
    String? name,
    String? email,
    String? profileImage,
    String? preferredCurrency,
    String? units,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      units: units ?? this.units,
    );
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is User && runtimeType == other.runtimeType && id == other.id;

  @override
    int get hashCode => id.hashCode;

  @override
  String toString(){
    return'User(id:$id, name:$name,  email: $email)';
  }
}