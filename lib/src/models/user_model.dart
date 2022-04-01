class Userlist {
  String? name;
  String? email;
  String? country;


  Userlist(
      {this.name,
      this.email,
      this.country});

  Userlist.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    country = json['country'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['country'] = this.country;
    return data;
  }
}}