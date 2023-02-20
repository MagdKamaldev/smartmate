class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uid;
  String? image;
 
  UserModel(
      {this.email, this.name, this.phone, this.uid, this.image, });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    name = json["name"];
    phone = json["phone"];
    image = json["image"];
    uid = json["uid"];
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "uid": uid,
      "image":image,
    };
  }
}
