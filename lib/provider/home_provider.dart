import 'package:archapp/data/repository/get_currency_repository.dart';
import 'package:archapp/helpers/show_message_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../data/model/currency_model.dart';

class HomeProvider extends ChangeNotifier {
  GetCurrencyRepository userRepository = GetCurrencyRepository();
  HomeProvider() {
    getUser();
  }
  bool isLoading = false;
  String errorMessage = "";
  void getUser() async {
    isLoading = true;
    notifyListeners();
    await userRepository.getCurrency().then((dynamic response) {
      if (response is Box<CurrencyModel>) {
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        errorMessage = response.toString();
        notifyListeners();
      }
    });
  }

  Future<void> update() async {
    getUser();
  }

  void deleteUser(String user) async {
    await userRepository.deleteuser(user);
    notifyListeners();
  }
}
