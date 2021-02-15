import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_login/data/join_or_login.dart';
import 'package:firebase_auth_login/helper/login_background.dart';
import 'package:firebase_auth_login/screens/forget_pw.dart';
import 'package:firebase_auth_login/screens/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: size,
            painter: LoginBackground(isJoin: Provider
                .of<JoinOrLogin>(context)
                .isJoin),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _logoImage,
                Stack(
                  children: <Widget>[
                    _inputForm(size),
                    _authButton(size),
                  ],
                ),
                Container(
                  height: size.height * 0.1,
                ),
                Consumer<JoinOrLogin>(
                  builder: (context, JoinOrLogin,
                      child) => //BuildContext context, JoinOrLogin value, Widget child
                  GestureDetector( //text에 대한 터치 이벤트
                      onTap: () {
                        JoinOrLogin.toggle();
                        //joinOrLogin의 toggle()을 사용해서 notifyListeners()로 사용하는 위젯에 알림을 보냄
                        //위의 custompaint/LoginBackground에 isJoin의 값을 전달하여 배경색 지정
                      },
                      child: Text(JoinOrLogin.isJoin
                          ? "Already Have an Account? Sign in"
                          : "Don't Have an Account? Create one",
                        style: TextStyle(
                            color: JoinOrLogin.isJoin ? Colors.red : Colors
                                .blue),)),
                ),
                Container(
                  height: size.height * 0.05,
                )
              ])
        ],
      ),
    );
  }

  void _register(BuildContext context) async {
      final UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      final User user = result.user;

      if (user == null) {
        final snacBar = SnackBar(
          content: Text('Please try again later.'),
        );
        Scaffold.of(context).showSnackBar(snacBar);
      }

//    Navigator.push(context,
//      MaterialPageRoute(builder: (context) => MainPage(email: user.email)));
  }

  void _login(BuildContext context) async {
    try {
      final UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      final User user = result.user;

      if (user == null) {
        final snacBar = SnackBar(content: Text('Please try again later.'),);
        Scaffold.of(context).showSnackBar(snacBar);
      }
    }on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
//    Navigator.push(context,
//      MaterialPageRoute(builder: (context) => MainPage(email: user.email)));
  }


  Widget _authButton(Size size) =>
      Positioned(
        left: size.width * 0.15,
        right: size.width * 0.15,
        bottom: 0,
        child: SizedBox(
          height: 50,
          child: Consumer<JoinOrLogin>(
            builder: (context, joinOrLogin, child) =>
                RaisedButton(
                  child: Text(
                      joinOrLogin.isJoin ? "Join" : "Login",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  color: joinOrLogin.isJoin ? Colors.red : Colors.blue,
                  shape:
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      joinOrLogin.isJoin?_register(context):_login(context);
//                      print("button pressed!!"); //validate 통과 하면 실행
//                      print(_emailController.text.toString()); //값도 전달 가능
                    }
                  },
                ),
          ),
        ),
      );

  Widget _inputForm(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 6, //그림자
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12,
            bottom: 32,
          ),
          child: Form(
              key: _formKey, //유니크한 아이디
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle),
                        labelText: "Email",
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please input correct Email.";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key),
                        labelText: "Password",
                      ),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "Please input correct Password.";
                        }
                        return null;
                      },
                    ),
                    Container(
                      height: 8,
                    ),
                    Consumer<JoinOrLogin>(
                      builder: (context, value, child) =>
                          Opacity(
                              opacity: value.isJoin ? 0 : 1, //opacity 투명함
                              child: GestureDetector(
                                  onTap: value.isJoin ? null : (){goToForgetPW(context);},
                                  child: Text("Forgot Password"))),
                    )
                  ]
              )
          ),
        ),
      ),
    );
  }
  goToForgetPW(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPw()));
  }

  //파라미터가 없으면 get으로 주면 됨
  Widget get _logoImage =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 24, right: 24,),
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://picsum.photos/200"),
//                backgroundImage: AssetImage("assets/loading.gif"),
            ),
          ),
        ),
      );
}
