class ErrorsModel {
  final List<String>? email;
  final List<String>? password;

  ErrorsModel({this.email, this.password});

  factory ErrorsModel.fromJson(Map<String, dynamic> jsonData) {
    return ErrorsModel(
      email: (jsonData['email'] as List?)?.map((e) => e.toString()).toList(),
      password: (jsonData['password'] as List?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }
}
