import 'package:get/get.dart';

import '../models/test_user_model.dart';

class TestUserProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return TestUser.fromJson(map);
      if (map is List)
        return map.map((item) => TestUser.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<TestUser?> getTestUser(int id) async {
    final response = await get('testuser/$id');
    return response.body;
  }

  Future<Response<TestUser>> postTestUser(TestUser testuser) async =>
      await post('testuser', testuser);
  Future<Response> deleteTestUser(int id) async => await delete('testuser/$id');
}
