import 'package:e_commers_app/pages/account/login.dart';
import 'package:e_commers_app/pages/config.dart';
import 'package:e_commers_app/pages/home/home.dart';
import 'package:e_commers_app/pages/provider/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  gCusIdVal = prefs!.getString(gCusId)?? 'lage';
  runApp(const Splash());
}
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);  

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<LoadingControl>(
            create: (context) => LoadingControl(),
          )
        ],
        child: MaterialApp(
            theme: ThemeData(fontFamily: 'GE_ar'),
            debugShowCheckedModeBanner: false,
            home:  SplashScreen(
              seconds: 3,
              routeName: "/",
              navigateAfterSeconds:
                  // ignore: unnecessary_null_comparison
                  gCusIdVal == null ?  const Login() :  const Home(),
              title:  const Text(
                'مرحبا بكم في تطبيق ادارة المطعم',
                style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.white),
              ),
              /*image: new Image.network(
          'https://flutter.io/images/catalog-widget-placeholder.png'),*/
              backgroundColor: primaryColor,
              styleTextUnderTheLoader: const TextStyle(),
              photoSize: 100.0,
              onClick: () => print("restaurant"),
              loaderColor: Colors.white,
            )));
  }
}



// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:e_commers_app/pages/home/home.dart';
// import 'package:e_commers_app/pages/provider/cart.dart';
// import 'package:e_commers_app/pages/provider/loading.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:e_commers_app/pages/config.dart';
// import 'package:splashscreen/splashscreen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   prefs = await SharedPreferences.getInstance();
//   runApp(const Splash());
// }

// //343434
// class Splash extends StatefulWidget {
//   const Splash({Key? key}) : super(key: key);

//   @override
//   _SplashState createState() => _SplashState();
// }

// class _SplashState extends State<Splash> {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//         providers: [
//           ChangeNotifierProvider<LoadingControl>(
//             create: (context) => LoadingControl(),
//           ),
//           ChangeNotifierProvider<Cart>(
//             create: (context) => Cart(),
//           )
//         ],
//         child: MaterialApp(
//             theme: ThemeData(fontFamily: 'GE_ar'),
//             debugShowCheckedModeBanner: false,
//             home:  SplashScreen(
//               seconds: 3,
//               routeName: "/",
//               navigateAfterSeconds:
//                    const Home(),
//               title:  const Text(
//                 'مرحبا بكم في تطبيق المطعم',
//                 style:  TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20.0,
//                     color: Colors.white),
//               ),
//               /*image: new Image.network(
//           'https://flutter.io/images/catalog-widget-placeholder.png'),*/
//               backgroundColor: primaryColor,
//               styleTextUnderTheLoader:  const TextStyle(),
//               photoSize: 100.0,
//               onClick: () => print("restaurant"),
//               loaderColor: Colors.white,
//             )));
//   }
// }