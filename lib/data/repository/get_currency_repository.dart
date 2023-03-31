import 'dart:io';
import 'package:archapp/data/model/currency_model.dart';
import 'package:archapp/data/service/get_currency_service.dart';
import 'package:archapp/helpers/show_message_helper.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class GetCurrencyRepository {
  GetCurrencyService currencyService = GetCurrencyService();
  Box<CurrencyModel>? currencyBox;
  Future<dynamic> getCurrency() async {
    return await currencyService.getCurrency().then((dynamic response) async {
      if (response is List<CurrencyModel>) {
        await openBox();
        await putToBox(response);
        return currencyBox;
      } else {
        return response.toString();
      }
    });
  }

  Future<void> openBox() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
    currencyBox = await Hive.openBox<CurrencyModel>("currencyBox");
  }

  Future<void> putToBox(List<CurrencyModel> data) async {
    await currencyBox!.clear();
    for (CurrencyModel element in data) {
      await currencyBox!.add(element);
         }
  }

  void registerAdapters() {
    Hive.registerAdapter(CurrencyModelAdapter());
    Hive.registerAdapter(AddressAdapter());
    Hive.registerAdapter(GeoAdapter());
    Hive.registerAdapter(CompanyAdapter());
  }

  Future<void> deleteuser(String id) async {
    for (int i = 0; i < currencyBox!.length; i++) {
      if (currencyBox!.getAt(i)!.id.toString() == id) {
        await currencyBox!.deleteAt(i);
      }
    }
  }
}
