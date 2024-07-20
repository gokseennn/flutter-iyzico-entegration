import 'package:get/get.dart';
import 'package:iyzico_payment/iyzico_payment.dart';
import 'package:iyzico_payment/model/address.dart';
import 'package:iyzico_payment/model/basket_item.dart';
import 'package:iyzico_payment/model/buyer.dart';
import 'package:iyzico_payment/model/payment.dart';
import 'package:iyzico_payment/model/payment_card.dart';
import 'package:paytr/payment_success/PaymentSuccessScreen.dart';

class HomeController extends GetxController {
  final IyzicoPayment iyzicoPayment = IyzicoPayment(
      apiKey: "sandbox-Mri1odQXavRuRUWRsEJXcHCmI9NZhYaW",
      secretKey: "sandbox-JXpLRKDfONTPdgDobsiH4ObkkcfrrUHD");

  final isLoading = false.obs;

  Future<void> pay() async {
    isLoading.value = true;
    try {
      final response = await iyzicoPayment.createPayment(
        PaymentRequest(
          locale: "tr",
          conversationId: "123456789",
          price: "1.0",
          paidPrice: "1.1",
          installment: 1,
          paymentChannel: "WEB",
          basketId: "B67832",
          paymentGroup: "PRODUCT",
          paymentCard: PaymentCard(
            cardHolderName: "John Doe",
            cardNumber: "5528790000000008",
            expireYear: "2030",
            expireMonth: "12",
            cvc: "123",
            registerCard: 0,
          ),
          buyer: Buyer(
            id: "BY789",
            name: "John",
            surname: "Doe",
            identityNumber: "74300864791",
            email: "email@email.com",
            gsmNumber: "+905350000000",
            registrationDate: "2013-04-21 15:12:09",
            lastLoginDate: "2015-10-05 12:43:35",
            registrationAddress:
                "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
            city: "Istanbul",
            country: "Turkey",
            zipCode: "34732",
            ip: "85.34.78.112",
          ),
          shippingAddress: Address(
            address: "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
            zipCode: "34742",
            contactName: "Jane Doe",
            city: "Istanbul",
            country: "Turkey",
          ),
          billingAddress: Address(
            address: "Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1",
            contactName: "Jane Doe",
            city: "Istanbul",
            country: "Turkey",
            zipCode: '81650',
          ),
          basketItems: [
            BasketItem(
              id: "BI101",
              price: "0.3",
              name: "Binocular",
              category1: "Collectibles",
              category2: "Accessories",
              itemType: "PHYSICAL",
            ),
            BasketItem(
              id: "BI102",
              price: "0.5",
              name: "Game code",
              category1: "Game",
              category2: "Online Game Items",
              itemType: "VIRTUAL",
            ),
            BasketItem(
              id: "BI103",
              price: "0.2",
              name: "Usb",
              category1: "Electronics",
              category2: "Usb / Cable",
              itemType: "PHYSICAL",
            ),
          ],
          currency: "TRY",
        ),
      );
      Get.to(
        const PaymentSuccessScreen(),
      );
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
