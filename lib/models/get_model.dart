class Datum {
  final String id;
  final String type;
  final Attributes attributes;

  Datum({
    required this.id,
    required this.type,
    required this.attributes,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      attributes: Attributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class Attributes {
  final String? messageReceivedFromPartnerAt;
  final int? authUserId;
  final String name;
  final String username;
  final String email;
  final String? profilePhotoPath;
  final String? profilePhotoId;
  final String phone;
  final String gender;
  final int? countryId;
  final String? countryName;
  final int? stateId;
  final String? stateName;
  final int? cityId;
  final String? cityName;
  final String? customCityName;
  final bool isActive;
  final String customerCode;
  final bool isPremiumCustomer;
  final bool isOnline;
  final String? bioIntroText;
  final String? lastActiveAt;
  final String? dateOfBirth;
  final int? nativeLanguageId;
  final String? nativeLanguageName;
  final String profilePhotoUrl;
  final String square100ProfilePhotoUrl;
  final String square300ProfilePhotoUrl;
  final String square500ProfilePhotoUrl;
  final int age;

  Attributes({
    this.messageReceivedFromPartnerAt,
    this.authUserId,
    required this.name,
    required this.username,
    required this.email,
    this.profilePhotoPath,
    this.profilePhotoId,
    required this.phone,
    required this.gender,
    this.countryId,
    this.countryName,
    this.stateId,
    this.stateName,
    this.cityId,
    this.cityName,
    this.customCityName,
    required this.isActive,
    required this.customerCode,
    required this.isPremiumCustomer,
    required this.isOnline,
    this.bioIntroText,
    this.lastActiveAt,
    this.dateOfBirth,
    this.nativeLanguageId,
    this.nativeLanguageName,
    required this.profilePhotoUrl,
    required this.square100ProfilePhotoUrl,
    required this.square300ProfilePhotoUrl,
    required this.square500ProfilePhotoUrl,
    required this.age,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      messageReceivedFromPartnerAt: json['message_received_from_partner_at'],
      authUserId: json['auth_user_id'],
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      profilePhotoPath: json['profile_photo_path'],
      profilePhotoId: json['profile_photo_id'],
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      countryId: json['country_id'],
      countryName: json['country_name'],
      stateId: json['state_id'],
      stateName: json['state_name'],
      cityId: json['city_id'],
      cityName: json['city_name'],
      customCityName: json['custom_city_name'],
      isActive: json['is_active'] ?? false,
      customerCode: json['customer_code'] ?? '',
      isPremiumCustomer: json['is_premium_customer'] ?? false,
      isOnline: json['is_online'] ?? false,
      bioIntroText: json['bio_intro_text'],
      lastActiveAt: json['last_active_at'],
      dateOfBirth: json['date_of_birth'],
      nativeLanguageId: json['native_language_id'],
      nativeLanguageName: json['native_language_name'],
      profilePhotoUrl: json['profile_photo_url'] ?? '',
      square100ProfilePhotoUrl: json['square100_profile_photo_url'] ?? '',
      square300ProfilePhotoUrl: json['square300_profile_photo_url'] ?? '',
      square500ProfilePhotoUrl: json['square500_profile_photo_url'] ?? '',
      age: json['age'] ?? 0,
    );
  }
}