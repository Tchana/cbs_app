part of 'login_data.dart';

Map<String, dynamic> _$LoginDataToJson(_LoginData instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password,
    };

_LoginData _$LoginDataFromJson(Map<String, dynamic> json) => _LoginData(
      id: json['id'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
    );

