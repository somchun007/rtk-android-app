// ignore_for_file: file_names

class Address {
  double? latitude;
  double? longitude;
  String? road;
  String? subdistrict;
  String? district;
  String? province;
  String? country;
  String? postcode;
  int? elevation;

  Address({
    this.latitude,
    this.longitude,
    this.road,
    this.subdistrict,
    this.district,
    this.province,
    this.country,
    this.postcode,
    this.elevation,
  });

  @override
  String toString() {
    return 'latitude: $latitude, longtitude: $longitude, road: $road, subdistrict: $subdistrict, district: $district, province: $province, country: $country, postcode: $postcode, elevation: $elevation';
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      latitude: json['road_lat'], //latitude
      longitude: json['road_lon'], //longitude
      road: json['road'], //ถนน
      subdistrict: json['subdistrict'], //ตำบล
      district: json['district'], //อำเภอ
      province: json['province'], //จังหวัด
      country: json['country'], //ประเทศ
      postcode: json['postcode'], //ไปรษณีย์
      elevation: json['elevation'],
    ); //ความสูงน้ำ
  }
}
