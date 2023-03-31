import 'package:archapp/core/network/dio_config.dart';
import 'package:archapp/core/network/dio_error_catch_config.dart';
import 'package:archapp/data/model/currency_model.dart';
import 'package:dio/dio.dart';
import 'package:archapp/core/constans/projec_url.dart';
class GetCurrencyService {
  Future<dynamic> getCurrency() async {
    try {
      Response response = await DioConfig.createRequest().get(ProjecUrls.urls);
      if (response.statusCode == 200) {
      
        return (response.data as List)
            .map((e) => CurrencyModel.fromJson(e))
            .toList();
      } else {
        return "${response.statusCode.toString()} ${response.statusMessage}";
      }
    } on DioError catch (e) {
      return DioHandleCatchError.hendleCatchError(e);
    }
  }
}
