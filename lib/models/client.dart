class Client {
  final String id;
  final String companyId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String address;

  Client({
    required this.id,
    required this.companyId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.address,
  });

  String get fullName => '$firstName $lastName';

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['client_id'].toString(),
      companyId: json['company_id'].toString(),
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
    );
  }
} 