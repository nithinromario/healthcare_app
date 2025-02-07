import '../models/user.dart';

abstract class AuthViewContract {
  void onLoginSuccess(User user);
  void onLoginError(String error);
  void onSignupSuccess(User user);
  void onSignupError(String error);
}

class AuthPresenter {
  final AuthViewContract view;

  AuthPresenter(this.view);

  Future<void> login(String email, String password) async {
    try {
      // TODO: Implement actual login logic with backend
      final user = User(
        id: '1',
        name: 'John Doe',
        email: email,
        phone: '1234567890',
        userType: UserType.patient,
      );
      view.onLoginSuccess(user);
    } catch (e) {
      view.onLoginError(e.toString());
    }
  }
} 