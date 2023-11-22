enum UserDataEnum {
  age,
  height,
  weight,
  email,
  name,
  password,
  token,
}

class User {
  User({
    int? age,
    int? height,
    int? weight,
    String? email,
    String? name,
    String? password,
    String? token,
  }) {
    _age = age;
    _height = height;
    _weight = weight;
    _email = email;
    _name = name;
    _password = password;
    _token = token;
  }

  String? _name;
  String? _email;
  String? _password;
  int? _height;
  int? _weight;
  int? _age;
  String? _token;

  Map<UserDataEnum, dynamic> getUserData() {
    return {
      UserDataEnum.age: _age,
      UserDataEnum.height: _height,
      UserDataEnum.weight: _weight,
      UserDataEnum.email: _email,
      UserDataEnum.name: _name,
      UserDataEnum.password: _password,
      UserDataEnum.token: _token,
    };
  }

  set age(int age) {
    _age = age;
  }

  set height(int height) {
    _height = height;
  }

  set weight(int weight) {
    _weight = weight;
  }

  set name(String name) {
    _name = name;
  }

  set email(String email) {
    _email = email;
  }

  set password(String password) {
    _password = password;
  }

  set token(String token) {
    _token = token;
  }
}
