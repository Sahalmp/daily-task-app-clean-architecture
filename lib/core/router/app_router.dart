import 'package:auto_route/auto_route.dart';
import '../../presentation/screens/add_task/add_task_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/report/report_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, path: '/'),
        AutoRoute(page: AddTaskRoute.page, path: '/addtask'),
        AutoRoute(page: ReportRoute.page, path: '/report'),
      ];
}