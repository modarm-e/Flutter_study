import 'package:flutter/foundation.dart';

class JoinOrLogin extends ChangeNotifier{ //ChangeNotification을 사용하면
            //즉 이 클래스를 사용하면 알림을 받는다
  // 상태 변환 처리
  bool _isJoin = false;

  bool get isJoin => _isJoin;

  void toggle(){
    _isJoin = !_isJoin;
    notifyListeners();//사용하고있는 위젯에게 알림을 보내줌
  }

}