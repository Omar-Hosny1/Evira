import 'dart:io';

enum UserDataEnum {
  age,
  height,
  weight,
  email,
  name,
  password,
  image,
  imagePath
}

class User {
  User({
    int? age,
    int? height,
    int? weight,
    String? email,
    String? name,
    String? password,
    File? image,
    String? imagePath,
  }) {
    _age = age;
    _height = height;
    _weight = weight;
    _email = email;
    _name = name;
    _password = password;
    _image = image;
    _imagePath = imagePath;
  }

  String? _name;
  String? _email;
  String? _password;
  int? _height;
  int? _weight;
  int? _age;
  File? _image;
  String? _imagePath;

  Map<String, dynamic> toJson() => {
        'age': _age,
        'height': _height,
        'weight': _weight,
        'email': _email,
        'name': _name,
        'password': _password,
        'imagePath': _imagePath,
      };

  Map<UserDataEnum, dynamic> getUserData() {
    return {
      UserDataEnum.age: _age,
      UserDataEnum.height: _height,
      UserDataEnum.weight: _weight,
      UserDataEnum.email: _email,
      UserDataEnum.name: _name,
      UserDataEnum.password: _password,
      UserDataEnum.image: _image,
      UserDataEnum.imagePath: _imagePath,
    };
  }

  set age(int age) {
    _age = age;
  }

  set height(int height) {
    _height = height;
  }

  set imagePath(String imagePath) {
    _imagePath = imagePath;
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

  set image(File image) {
    _image = image;
  }
}
