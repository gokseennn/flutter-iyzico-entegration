import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  String name = "asd";
  final String apiKey = "sandbox-Mri1odQXavRuRUWRsEJXcHCmI9NZhYaW";
  final String secretKey = "sandbox-JXpLRKDfONTPdgDobsiH4ObkkcfrrUHD";

  // Durum değişkenleri
  final isLoading = false.obs;
  final responseMessage = ''.obs;

  // Yardımcı fonksiyonlar
  String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  String generateRequestString(Map<String, dynamic> obj) {
    // Bu fonksiyonu orijinal JavaScript kodundan Dart'a çevirmeniz gerekecek
    // Şimdilik basit bir implementasyon:
    return jsonEncode(obj);
  }

  String generateAuthorizationString(
      Map<String, dynamic> obj, String xIyziRnd) {
    String requestString = generateRequestString(obj);
    String hashInput = apiKey + xIyziRnd + secretKey + requestString;
    var bytes = utf8.encode(hashInput);
    var digest = sha1.convert(bytes);
    String hashInBase64 = base64.encode(digest.bytes);
    return "IYZWS $apiKey:$hashInBase64";
  }

  Future<void> createPayment() async {
    isLoading.value = true;
    responseMessage.value = '';

    // İstek URL'si
    final url = Uri.https('https://sandbox-api.iyzipay.com/payment/auth');

    // x-iyzi-rnd değeri oluştur
    final xIyziRnd = generateRandomString(8);

    // requestModel oluştur (bu örnek için basitleştirilmiş)
    final requestModel = {
      'locale': 'tr',
      'conversationId': '123456789',
      'price': '1',
      'paidPrice': '1.2',
      'currency': 'TRY',
      'installment': '1',
      'basketId': 'B67832',
      'paymentChannel': 'WEB',
      'paymentGroup': 'PRODUCT',
      // Diğer gerekli alanları ekleyin
    };

    // Authorization header'ını oluştur
    final authorization = generateAuthorizationString(requestModel, xIyziRnd);

    // Headers
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': authorization,
      'x-iyzi-rnd': xIyziRnd,
    };

    try {
      // POST isteği gönder
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestModel),
      );

      // Yanıtı kontrol et
      if (response.statusCode == 200) {
        responseMessage.value = 'İşlem başarılı: ${response.body}';
      } else {
        responseMessage.value =
            'Hata oluştu: ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      responseMessage.value = 'Bir hata oluştu: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
