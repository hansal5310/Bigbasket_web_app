class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profilePicture;
  final List<Address> addresses;
  final String? defaultAddressId;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePicture,
    this.addresses = const [],
    this.defaultAddressId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profilePicture: json['profilePicture'],
      addresses: (json['addresses'] as List?)
              ?.map((e) => Address.fromJson(e))
              .toList() ??
          [],
      defaultAddressId: json['defaultAddressId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profilePicture': profilePicture,
      'addresses': addresses.map((e) => e.toJson()).toList(),
      'defaultAddressId': defaultAddressId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profilePicture,
    List<Address>? addresses,
    String? defaultAddressId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePicture: profilePicture ?? this.profilePicture,
      addresses: addresses ?? this.addresses,
      defaultAddressId: defaultAddressId ?? this.defaultAddressId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Address {
  final String id;
  final String name;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final bool isDefault;
  final String addressType; // home, office, other

  Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    this.isDefault = false,
    required this.addressType,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      landmark: json['landmark'],
      isDefault: json['isDefault'] ?? false,
      addressType: json['addressType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'landmark': landmark,
      'isDefault': isDefault,
      'addressType': addressType,
    };
  }

  String get fullAddress {
    return '$addressLine1, $addressLine2, $city, $state - $pincode';
  }

  Address copyWith({
    String? id,
    String? name,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    String? landmark,
    bool? isDefault,
    String? addressType,
  }) {
    return Address(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      landmark: landmark ?? this.landmark,
      isDefault: isDefault ?? this.isDefault,
      addressType: addressType ?? this.addressType,
    );
  }
}
