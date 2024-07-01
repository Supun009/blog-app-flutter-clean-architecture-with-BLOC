import 'package:blogapp/features/auth/domain/usecases/current_user.dart';
import 'package:blogapp/features/auth/domain/usecases/user_login.dart';
import 'package:blogapp/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubit/cubit/app_cbit_cubit.dart';
import '../../../../core/common/entities/user.dart';
import '../../domain/repository/auth_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppCbitCubit _appCbitCubit;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required this.authRepository,
    required CurrentUser currentUser,
    required AppCbitCubit appCbitCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appCbitCubit = appCbitCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_authSignUp);
    on<AuthLogin>(_onAuthLoging);
    on<AppStarted>(_onAppStarted);
    // on<AppStarted>(_onAppStarted);
  }

  void _authSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp.call(
      UserSignUpParams(
        email: event.email,
        name: event.name,
        password: event.password,
      ),
    );
    res.fold(
      (l) => emit(AuthFailuer(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthLoging(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin.call(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (l) => emit(AuthFailuer(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final result = await _currentUser.call(CurrenUserParams());

    result.fold(
      (failure) => emit(AuthFailuer(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appCbitCubit.updateUSer(user);
    emit(AuthSuccess(user));
  }
}
