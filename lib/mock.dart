import 'package:flutter_firebase_ddd_course/domain/auth/i_auth_facade.dart';
import 'package:injectable/injectable.dart';
import 'package:mocktail/mocktail.dart';

@test
@LazySingleton(as: IAuthFacade)
class MockIAuthFacade extends Mock implements IAuthFacade {}

