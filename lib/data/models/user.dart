import 'dart:io';

enum UserDataEnum {
  age,
  height,
  weight,
  email,
  name,
  password,
  image,
  imagePath,
  token,
  tokenExpiresIn,
  gender
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
    String? token,
    String? tokenExpiresIn,
    String? gender,
  }) {
    _age = age;
    _height = height;
    _weight = weight;
    _email = email;
    _name = name;
    _password = password;
    _image = image;
    _imagePath = imagePath;
    _token = token;
    _tokenExpiresIn = tokenExpiresIn;
    _gender = gender;
  }

  String? _name;
  String? _email;
  String? _password;
  int? _height;
  int? _weight;
  int? _age;
  File? _image;
  String? _imagePath;
  String? _token;
  String? _tokenExpiresIn;
  String? _gender;

  Map<String, dynamic> toJson() => {
        'age': _age,
        'height': _height,
        'weight': _weight,
        'email': _email,
        'name': _name,
        'password': _password,
        'imagePath': _imagePath,
        'token': _token,
        'tokenExpiresIn': _tokenExpiresIn,
        'gender': _gender,
      };

  Map<String, dynamic> toJsonToFireStore() => {
        'age': _age,
        'height': _height,
        'weight': _weight,
        'email': _email,
        'name': _name,
        'imagePath': _imagePath,
        'gender': _gender,
      };

  factory User.fromJson(Map userData) => User(
        age: userData['age'],
        email: userData['email'],
        height: userData['height'],
        image: userData['image'],
        imagePath: userData['imagePath'],
        name: userData['name'],
        password: userData['password'],
        weight: userData['weight'],
        token: userData['token'],
        tokenExpiresIn: userData['tokenExpiresIn'],
        gender: userData['gender'],
      );

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
      UserDataEnum.token: _token,
      UserDataEnum.tokenExpiresIn: _tokenExpiresIn,
      UserDataEnum.gender: _gender,
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

  set token(String token) {
    _token = token;
  }

  set gender(String gender) {
    _gender = gender;
  }

  set tokenExpiresIn(String tokenExpiresIn) {
    _tokenExpiresIn = tokenExpiresIn;
  }

  String? get getEmail {
    return _email;
  }

  String? get getPassword {
    return _password;
  }

  String? get getName {
    return _name;
  }

  int? get getAge {
    return _age;
  }

  int? get getHeight {
    return _height;
  }

  int? get getWeight {
    return _weight;
  }

  String? get getImagePath {
    return _imagePath;
  }

  String? get getToken {
    return _token;
  }

  String? get getTokenExpiresIn {
    return _tokenExpiresIn;
  }
  
  String? get getGender {
    return _gender;
  }
}
