class UserModel {
  String? uid;
  String? email;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? photoUrl;
  String? lastSignIn;

  UserModel(
      {this.uid,
      this.email,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.photoUrl,
      this.lastSignIn});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    photoUrl = json['photoUrl'];
    lastSignIn = json['lastSignIn'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['email'] = email;
    data['name'] = name;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['photoUrl'] = photoUrl;
    data['lastSignIn'] = lastSignIn;
    return data;
  }
}
