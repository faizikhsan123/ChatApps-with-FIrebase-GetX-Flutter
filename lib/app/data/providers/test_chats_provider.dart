import 'package:get/get.dart';

import '../models/test_chats_model.dart';

class TestChatsProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return TestChats.fromJson(map);
      if (map is List)
        return map.map((item) => TestChats.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<TestChats?> getTestChats(int id) async {
    final response = await get('testchats/$id');
    return response.body;
  }

  Future<Response<TestChats>> postTestChats(TestChats testchats) async =>
      await post('testchats', testchats);
  Future<Response> deleteTestChats(int id) async =>
      await delete('testchats/$id');
}
