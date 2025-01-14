class Client {
  final String id;
  final String companyId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String mobileNumber;
  final String address;
  final double totalOverdueAmount;
  final double totalDraftedAmount;
  final double totalPaidAmount;
  final int totalInvoicesSent;
  final int totalInvoicesDrafted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Client({
    required this.id,
    required this.companyId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.mobileNumber,
    required this.address,
    this.totalOverdueAmount = 0,
    this.totalDraftedAmount = 0,
    this.totalPaidAmount = 0,
    this.totalInvoicesSent = 0,
    this.totalInvoicesDrafted = 0,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'mobileNumber': mobileNumber,
      'address': address,
    };
  }

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'].toString(),
      companyId: json['companyId'].toString(),
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      mobileNumber: json['mobileNumber'] ?? '',
      address: json['address'],
      totalOverdueAmount: (json['totalOverdueAmount'] ?? 0).toDouble(),
      totalDraftedAmount: (json['totalDraftedAmount'] ?? 0).toDouble(),
      totalPaidAmount: (json['totalPaidAmount'] ?? 0).toDouble(),
      totalInvoicesSent: json['totalInvoicesSent'] ?? 0,
      totalInvoicesDrafted: json['totalInvoicesDrafted'] ?? 0,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
