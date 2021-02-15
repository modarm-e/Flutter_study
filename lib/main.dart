import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_login/data/join_or_login.dart';
import 'package:firebase_auth_login/screens/login.dart';
import 'package:firebase_auth_login/screens/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
    );
  }
}

class Splash extends StatelessWidget { //처음 앱을 실행할때 로고 보여주는 페이지 splash
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      // ignore: deprecated_member_use
      stream: FirebaseAuth.instance.onAuthStateChanged, //authStateChanges()으로 바뀜
      builder: (context, snapshot) {

        if(snapshot.data == null ){//로그인 안된 상태
        return ChangeNotifierProvider<JoinOrLogin>.value( //authPage모든곳에서 JoinOrLogin프로바이더 접근가능
            value: JoinOrLogin(),
            child: AuthPage());
        }else{
          return MainPage(email: snapshot.data.email);
        }
      }
    );
  }
}
