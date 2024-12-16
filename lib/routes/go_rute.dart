import 'package:fepi_local/routes/screens.dart';
import 'package:fepi_local/screens/home_aspirante.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/screen_pantalla_se00401',
  routes: [
    GoRoute(
      path: '/ScreenPantallaPl003_01',
      name: ScreenPantallaPl003_01.routeName,
      builder: (context, state) => ScreenPantallaPl003_01(),
    ),
     GoRoute(
      path: '/ScreenPantallaPl004_01',
      name: ScreenPantallaPl004_01.routeName,
      builder: (context, state) => ScreenPantallaPl004_01(),
    ),
     GoRoute(
      path: '/screen_pantalla_se003_01',
      name: SreenPantallaSe003_01.routeName,
      builder: (context, state) => SreenPantallaSe003_01(),
    ),
     GoRoute(
      path: '/screen__pantalla_pl013_01',
      name: ScreenPantallaPl013_01.routeName,
      builder: (context, state) => ScreenPantallaPl013_01(),
    ),
    GoRoute(
      path: '/screen_pantalla_pl014_01',
      name: DynamicCardsWidget2.routeName,
      builder: (context, state) => DynamicCardsWidget2(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.routeName,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/aspirantes_home',
      name: HomeScreenAsp.routeName,
      builder: (context, state) => HomeScreenAsp(),
    ),
    GoRoute(
      path: '/screen_pantalla_se00401',
      name: ScreenPantallaSe00401.routeName,
      builder: (contex , state) => ScreenPantallaSe00401(),

    )
  
    
  ],
);
