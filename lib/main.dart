import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/data/repositories/task_repository_impl.dart';
import 'package:todo_app/domain/usecases/usecases.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'presentation/cubit/report_cubit/report_cubit.dart';
import 'presentation/cubit/task_cubit/task_cubit.dart';
import 'presentation/cubit/theme_cubit/theme_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final TaskCubit taskCubit;
  late final ReportCubit reportCubit;
  late final UseCases useCases;

  @override
  void initState() {
    final repository = TaskRepositoryImpl();

    useCases = UseCases(repository);


    reportCubit = ReportCubit(useCases);
    taskCubit = TaskCubit(useCases: useCases, reportCubit: reportCubit)
      ..loadTasks();
    super.initState();
  }

  @override
  void dispose() {
    taskCubit.close();
    reportCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskCubit>.value(value: taskCubit),
        BlocProvider<ReportCubit>.value(value: reportCubit),
        BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return SafeArea(
            top: false,

            child: MaterialApp.router(
              title: 'Daily Checklist',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              routerConfig: AppRouter().config(),
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }

 
}
