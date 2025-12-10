import 'package:car_e_rescue/core/constants/theme/app_colors.dart';
import 'package:car_e_rescue/core/routes/page_routes_name.dart';
import 'package:flutter/material.dart';

class UserTypeViewModel extends ChangeNotifier{

  bool _client = true;
  void changeUser(bool newUser){
    if(_client == newUser) return;
    _client = newUser;
    notifyListeners();
  }
  bool isClient() => _client;

  Color setSelectedContainerColor(){
    return _client ? AppColors.red : AppColors.white;
  }
  Color setUnSelectedContainerColor(){
    return _client ? AppColors.white : AppColors.red;
  }

  String? signUpNavigator(){
    if(_client) {
      return PageRoutesName.clientSignUp;
    }else{
      return PageRoutesName.providerSignUp;
    }
  }

}