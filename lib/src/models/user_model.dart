class Userlist {
  String? username;


  Userlist(
      {this.username});

  Userlist.fromJson(Map<String, dynamic> json) {
    username = json['username'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.username;
    return data;
  }
}}