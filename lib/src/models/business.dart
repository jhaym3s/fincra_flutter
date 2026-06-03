/// Basic information about your Fincra business profile.
///
/// The business [id] is required by several endpoints (payouts, checkout),
/// so a typical first call after configuring the SDK is to fetch this and
/// cache the id.
class Business {
  const Business({
    required this.id,
    required this.name,
    this.email,
  });

  final String id;
  final String name;
  final String? email;

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? json['businessName'] ?? '').toString(),
      email: json['email']?.toString(),
    );
  }

  @override
  String toString() => 'Business($name, id: $id)';
}
