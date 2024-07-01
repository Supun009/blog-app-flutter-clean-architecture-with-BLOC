import 'package:blogapp/core/common/cubit/cubit/app_cbit_cubit.dart';
import 'package:blogapp/core/common/entities/widget/loader.dart';
import 'package:blogapp/core/theme/theme.dart';
import 'package:blogapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blogapp/features/auth/presentation/pages/login_page.dart';
import 'package:blogapp/features/blog/presetation/bloc/blog_bloc_bloc.dart';
import 'package:blogapp/features/blog/presetation/pages/blog_page.dart';
import 'package:blogapp/init_dependancies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependancies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AppCbitCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<BlogBlocBloc>(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AppStarted());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkThemeMode,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Loader();
            } else if (state is AuthSuccess) {
              return const BlogPage();
            } else {
              return const LoginPage();
            }
          },
        ));
  }
}
