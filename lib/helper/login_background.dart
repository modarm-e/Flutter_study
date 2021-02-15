import 'package:flutter/material.dart';

class LoginBackground extends CustomPainter{

  LoginBackground({@required this.isJoin});//클래스 생성자

  final bool isJoin;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = isJoin?Colors.red:Colors.blue; //Paint오브젝터에 색상 지정해서 사용
                                  //isJoin이 true면 red false면 blue
    canvas.drawCircle(Offset(size.width*0.5, size.height*0.2), size.height*0.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}