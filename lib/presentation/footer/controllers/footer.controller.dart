import 'package:get/get.dart';
import 'package:portfolio/presentation/info.fetch.controller.dart';

import '../../../domain/models/quote_model/quote.model.dart';

class FooterController extends GetxController {
  final InfoFetchController infoFetchController =
      Get.find<InfoFetchController>();

  RxList<QuoteModel> get quotes => infoFetchController.quotes;

  RxBool get isLoading => infoFetchController.isQuotesLoading;
}
