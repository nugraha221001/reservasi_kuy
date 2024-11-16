part of 'repositories.dart';

class AuthenticationRepo {
  late String token;
  late String error;
  late String role;
  late String user;
  late String agency;
  late String statusCode;

  /// fungsi login
  login(String username, String password) async {
    token = "";
    error = "";
    role = "";
    user = "";
    agency = "";

    try {
      QuerySnapshot resultUser = await Repositories()
          .db
          .collection("users")
          .where("username", isEqualTo: username.toLowerCase())
          .get();
      if (resultUser.docs.isNotEmpty) {
        final doc = resultUser.docs.first;
        if (doc["password"] == password) {
          token = "12341234";
          role = doc["role"];
          user = doc["username"];
          agency = doc["agency"];
        } else {
          error = "Kata sandi anda salah!";
        }
      } else {
        error = "Pengguna tidak ditemukan!";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// fungsi logout
  logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    statusCode = "200";
  }
}
