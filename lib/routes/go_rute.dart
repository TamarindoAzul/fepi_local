import 'package:fepi_local/routes/screens.dart';
import 'package:fepi_local/screens/home_aspirante.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
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

    ),
    GoRoute(
      path: '/screen_pantalla_se001',
      name: ScreenPantallaSe001.routeName,
      builder: (contex , state) => ScreenPantallaSe001(),

    ),

    GoRoute(
      path: '/screen_pantalla_eq00301',
      name: ScreenPantallaEq00301.routeName,
      builder: (contex , state) => ScreenPantallaEq00301(),

    ),
    GoRoute(
      path: '/scren_pantalla_se003_02',
      name: ScrenPantallaSe00302.routeName,
      builder: (contex , state) => ScrenPantallaSe00302(),

    ),
    GoRoute(
      path: '/scren_pantalla_se003_03',
      name: ScrenPantallaSe00303.routeName,
      builder: (contex , state) => ScrenPantallaSe00303(),

    ),
    GoRoute(path: '/screen_pantalla_se006_01',
    name: ScreenPantallaSe006_01.routeName,
    builder: (contex , state) => ScreenPantallaSe006_01(),
    ),
    GoRoute(path: '/screen_pantalla_eq02_02',
    name: FormularioEntrega.routeName,
    builder: (contex , state) => FormularioEntrega()),
    
  ],
);
