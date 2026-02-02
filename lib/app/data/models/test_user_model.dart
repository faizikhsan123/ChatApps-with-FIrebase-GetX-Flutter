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
  List<ChatsUser>? chats; //ganti chatsUser

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
      chats = <ChatsUser>[]; //ganti chatsUser
      json['chats'].forEach((v) {
        chats?.add(ChatsUser.fromJson(v));
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

class ChatsUser { //ganti chatsUser
  String? connection;
  String? chatId;
  String? lastTime;

  ChatsUser({this.connection, this.chatId, this.lastTime}); //ganti chatsUser

  ChatsUser.fromJson(Map<String, dynamic> json) { //ganti chatsUser
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
