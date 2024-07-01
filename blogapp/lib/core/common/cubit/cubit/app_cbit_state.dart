part of 'app_cbit_cubit.dart';

@immutable
sealed class AppCbitState {}

final class AppCbitInitial extends AppCbitState {}

final class AppUserLoggedIn extends AppCbitState {
  final User user;

  AppUserLoggedIn({
    required this.user,
  });
}
