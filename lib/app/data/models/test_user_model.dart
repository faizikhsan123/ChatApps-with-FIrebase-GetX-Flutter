class TestUser {
  String? uid;
  String? email;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? photoUrl;
  String? lastSignIn;
  String? keyName;
  List<Chats>? chats;

  TestUser(
      {this.uid,
      this.email,
      this.name,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.photoUrl,
      this.lastSignIn,
      this.keyName,
      this.chats});

  TestUser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    name = json['name'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    photoUrl = json['photoUrl'];
    lastSignIn = json['lastSignIn'];
    keyName = json['KeyName'];
    if (json['chats'] != null) {
      chats = <Chats>[];
      json['chats'].forEach((v) {
        chats?.add(Chats.fromJson(v));
      });
    }
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
    data['KeyName'] = keyName;
    if (chats != null) {
      data['chats'] = chats?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chats {
  String? connection;
  String? chatId;
  String? lastTime;

  Chats({this.connection, this.chatId, this.lastTime});

  Chats.fromJson(Map<String, dynamic> json) {
    connection = json['connection'];
    chatId = json['chat_id'];
    lastTime = json['lastTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['connection'] = connection;
    data['chat_id'] = chatId;
    data['lastTime'] = lastTime;
    return data;
  }
}
