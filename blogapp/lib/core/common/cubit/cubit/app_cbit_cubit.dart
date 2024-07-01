import 'package:blogapp/core/common/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'app_cbit_state.dart';

class AppCbitCubit extends Cubit<AppCbitState> {
  AppCbitCubit() : super(AppCbitInitial());

  void updateUSer(User? user) {
    if (user == null) {
      emit(AppCbitInitial());
    } else {
      emit(AppUserLoggedIn(user: user));
    }
  }
}
