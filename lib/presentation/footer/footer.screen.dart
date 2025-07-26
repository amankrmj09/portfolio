import 'package:flutter_svg/svg.dart';
import 'package:portfolio/infrastructure/navigation/bindings/controllers/info.fetch.controller.dart';
import 'package:portfolio/presentation/footer/views/contact_me_view.dart';
import 'package:portfolio/widgets/animated.navigate.button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../infrastructure/theme/colors.dart';
import '../../utils/k.showGeneralDialog.dart';
import '../../utils/launch.url.dart';
import 'controllers/footer.controller.dart';
import '../home/controllers/home.controller.dart';

class FooterScreen extends GetView<FooterController> {
  const FooterScreen({super.key});

  final Color _footerForegroundColor = const Color(0xFFC7D3B6);

  Widget _quoteSection({bool isMobile = false}) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.quotes.isEmpty) {
        return Center(
          child: Text(
            'No quotes available',
            style: TextStyle(color: _footerForegroundColor),
          ),
        );
      } else {
        final quotes = controller.quotes;
        final quote = (quotes.toList()..shuffle()).first;
        return Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                quote.quote,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 28 : 40,
                  fontFamily: "ShantellSans",
                  color: KColor.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  Text(
                    '— ${quote.author}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
            ],
          ),
        );
      }
    });
  }

  Widget _footerWelcomePart({bool isMobile = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            "Let's work together!",
            textAlign: TextAlign.center,
            maxLines: isMobile ? 1 : 2,
            style: TextStyle(
              color: _footerForegroundColor,
              fontSize: isMobile ? 28 : 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'ShantellSans',
            ),
          ),
        ),
        Text(
          "I'm available for Freelancing",
          textAlign: TextAlign.center,
          maxLines: isMobile ? 1 : 2,
          style: TextStyle(
            color: _footerForegroundColor,
            fontSize: isMobile ? 20 : 32,
            fontWeight: FontWeight.w400,
            fontFamily: 'ShantellSans',
          ),
        ),
      ],
    );
  }

  Widget _footerSocial({required bool swap}) {
    return swap
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(child: viewResumeButton()),
              Flexible(child: contactButton()),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [viewResumeButton(), contactButton()],
          );
  }

  Container viewResumeButton() {
    final homeController = Get.find<HomeController>();
    return Container(
      alignment: Alignment.centerLeft,
      height: 80,
      width: 200,
      child: AnimatedNavigateButton(
        borderRadius: 16,
        label: "View Resume",
        onTap: () =>
            launchUrlExternal(homeController.socialLinks.value?.resume ?? ''),
        icon: SvgPicture.asset(
          'assets/icons/resume.svg',
          width: 28,
          height: 28,
        ),
        width: 200,
      ),
    );
  }

  Container contactButton() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 80,
      width: 250,
      child: Builder(
        builder: (context) => AnimatedNavigateButton(
          borderRadius: 16,
          label: "Send Me a Message",
          onTap: () {
            showBlurredGeneralDialog(
              context: context,
              builder: (context) => ContactMeView(),
            );
          },
          icon: Image.asset(
            'assets/icons/contact_me.png',
            width: 28,
            height: 28,
            fit: BoxFit.fitHeight,
          ),
          width: 250,
        ),
      ),
    );
  }

  Widget _madeWithFlutterLabel() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Build using ',
          style: TextStyle(
            color: _footerForegroundColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const FlutterLogo(size: 18),
        Text(
          ' with much ',
          style: TextStyle(
            color: _footerForegroundColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Icon(Icons.favorite, color: Colors.red),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final InfoFetchController infoFetchController =
        Get.find<InfoFetchController>();
    bool isMobile = infoFetchController.currentDevice.value == Device.Mobile;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: isMobile ? kToolbarHeight : 124),
          Expanded(flex: 6, child: _quoteSection(isMobile: isMobile)),
          isMobile
              ? Expanded(
                  flex: 3,
                  child: SizedBox(
                    width: double.infinity,
                    child: ColoredBox(
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final swap = constraints.maxWidth < 600;
                            return swap
                                ? Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _footerWelcomePart(isMobile: isMobile),
                                      const SizedBox(height: 20, width: 20),
                                      viewResumeButton(),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _footerWelcomePart(isMobile: isMobile),
                                      const SizedBox(height: 20, width: 20),
                                      _footerSocial(swap: swap),
                                    ],
                                  );
                          },
                        ),
                      ),
                    ),
                  ),
                )
              : Expanded(
                  flex: 4,
                  child: ColoredBox(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 1, child: _footerWelcomePart()),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _madeWithFlutterLabel(),
                                FooterWidgets.ccLabel(_footerForegroundColor),
                              ],
                            ),
                          ),
                          Expanded(flex: 1, child: _footerSocial(swap: false)),
                          // SizedBox(width: 40),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class FooterWidgets {
  static Widget ccLabel(Color color) {
    return Text(
      '©️ 2025 Aman Kumar',
      style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w400),
    );
  }
}
