import 'package:firebase_auth/firebase_auth.dart' as firebase_auth show User;
import 'package:flutter_firebase_ddd_course/domain/auth/user.dart';
import 'package:flutter_firebase_ddd_course/domain/core/value_objects.dart';

extension FirebaseUserDomainX on firebase_auth.User {
  User toDomain() {
    return User(
      id: UniqueId.fromUniqueString(uid),
    );
  }
}
