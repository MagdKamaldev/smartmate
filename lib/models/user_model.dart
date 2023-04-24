import 'package:smartmate/models/messege_model.dart';

class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uid;
  String? image;
  String? bio;
  MessegeModel? lastMessege;

  UserModel({
    this.email,
    this.name,
    this.phone,
    this.uid,
    this.image,
    this.lastMessege,
    this.bio,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json["email"];
    name = json["name"];
    phone = json["phone"];
    image = json["image"];
    uid = json["uid"];
    lastMessege = json["lastMessege"];
    bio = json["bio"];
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "uid": uid,
      "image": image,
      "lastMessege": lastMessege,
      "bio": bio,
    };
  }
}
