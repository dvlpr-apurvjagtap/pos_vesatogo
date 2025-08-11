import 'package:hive/hive.dart';

part 'customer.g.dart';

@HiveType(typeId: 3)
class Customer extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String mobile;

  @HiveField(2)
  final String? firstName;

  @HiveField(3)
  final String? lastName;

  @HiveField(4)
  final String? email;

  @HiveField(5)
  final String? pincode;

  @HiveField(6)
  final String? city;

  @HiveField(7)
  final String? address;

  Customer({
    required this.id,
    required this.mobile,
    this.firstName,
    this.lastName,
    this.email,
    this.pincode,
    this.city,
    this.address,
  });

  String get displayName {
    if (firstName != null || lastName != null) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    return 'Customer';
  }

  String get shortInfo {
    final name = displayName;
    return name != 'Customer' ? '$name (${mobile})' : mobile;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile': mobile,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'pincode': pincode,
      'city': city,
      'address': address,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      mobile: json['mobile'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      pincode: json['pincode'],
      city: json['city'],
      address: json['address'],
    );
  }
}
