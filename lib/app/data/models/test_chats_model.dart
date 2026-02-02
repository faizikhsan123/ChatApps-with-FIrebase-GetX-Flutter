class TestChats {
  List<String>? connection;
  String? totalChat;
  String? totalReead;
  String? totalUnread;
  List<Chats>? chats;

  TestChats(
      {this.connection,
      this.totalChat,
      this.totalReead,
      this.totalUnread,
      this.chats});

  TestChats.fromJson(Map<String, dynamic> json) {
    connection = json['connection'].cast<String>();
    totalChat = json['total_chat'];
    totalReead = json['total_reead'];
    totalUnread = json['total_unread'];
    if (json['chats'] != null) {
      chats = <Chats>[];
      json['chats'].forEach((v) {
        chats?.add(Chats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['connection'] = connection;
    data['total_chat'] = totalChat;
    data['total_reead'] = totalReead;
    data['total_unread'] = totalUnread;
    if (chats != null) {
      data['chats'] = chats?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chats {
  String? pengirim;
  String? penerima;
  String? pesan;
  String? time;
  bool? isRead;

  Chats({this.pengirim, this.penerima, this.pesan, this.time, this.isRead});

  Chats.fromJson(Map<String, dynamic> json) {
    pengirim = json['pengirim'];
    penerima = json['penerima'];
    pesan = json['pesan'];
    time = json['time'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pengirim'] = pengirim;
    data['penerima'] = penerima;
    data['pesan'] = pesan;
    data['time'] = time;
    data['isRead'] = isRead;
    return data;
  }
}
