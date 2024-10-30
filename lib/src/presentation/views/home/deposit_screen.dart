// ignore_for_file: unnecessary_import, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';
import 'package:the_gemini_app/src/presentation/presentation.dart';
import 'package:the_gemini_app/src/presentation/widgets/supabase/supabase_inherited_widget.dart';
import 'package:the_gemini_app/src/providers/future_providers/user_future_provider.dart';

import 'package:the_gemini_app/src/providers/state_notifier_provider/boolean_state_notifier_provider.dart';
import 'package:http/http.dart' as http;
import 'package:the_gemini_app/src/providers/state_notifier_provider/string_state_notifier_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class DepositScreen extends ConsumerStatefulWidget {
  const DepositScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DepositScreenState();
}

class _DepositScreenState extends ConsumerState<DepositScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onChanged(String? value) {
    final container = ProviderScope.containerOf(context);

    if (value!.isEmpty) {
      container.read(amountFieldValidatorStateProvider.notifier).toggleOff();
    } else {
      container.read(amountFieldValidatorStateProvider.notifier).toggleOn();

      final amount = double.parse(value);
      if (amount == 0) {
        container.read(amountValidatorStateProvider.notifier).toggleOff();
      } else if (amount < 500) {
        container.read(amountValidatorStateProvider.notifier).toggleOff();
      } else if (amount > 100000) {
        container.read(amountValidatorStateProvider.notifier).toggleOff();
      } else {
        container.read(amountValidatorStateProvider.notifier).toggleOn();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20).w,
        height: MediaQuery.sizeOf(context).height * .45.h,
        child: Column(
          children: [
            Text(
              'Fund your Wallet',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontSize: 18.sp),
            ),
            Gap(5.h),
            Text(
              'Deposit funds into your Invest IQ wallet to unlock exclusive investment opportunities. Start growing your portfolio today with secure and flexible deposit options designed to help you reach your financial goals faster.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            Gap(20.h),
            Consumer(
              builder: (context, ref, child) {
                final passwordFiedValidator =
                    ref.watch(amountFieldValidatorStateProvider);

                final passwordValidator =
                    ref.watch(amountValidatorStateProvider);

                return CustomTextField(
                  controller: _controller,
                  hintText: 'Amount',
                  onChanged: onChanged,
                  sulfixIcon: passwordFiedValidator
                      ? passwordValidator
                          ? Icon(
                              Icons.check_circle_outline,
                              color: Palette.greenColor,
                              size: 18.h,
                            )
                          : Icon(
                              Icons.cancel_outlined,
                              color: Palette.redColor,
                              size: 18.h,
                            )
                      : null,
                  prefixIcon: Icon(
                    Icons.wallet_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18.h,
                  ),
                );
              },
            ),
            Gap(5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Minimum:\$ 500',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  'Maximum:\$ 100,000.00',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final isValid = ref.watch(amountValidatorStateProvider);
                    return CustomButton(
                      size: Size(MediaQuery.sizeOf(context).width, 40),
                      onTap: isValid
                          ? () async {
                              // Perform the network request to get the payment gateway.
                              showLoadingDialog(context);
                              const url =
                                  'https://cbrwyycbrwycfsbpnewm.supabase.co/functions/v1/payment-link-generator';

                              final id = MySupabaseConfig.of(context)
                                  .supabase
                                  .client
                                  .auth
                                  .currentUser
                                  ?.id;

                              print(id);

                              final amount = _controller.text.trim();
                              print(amount);
                              final data = {
                                "amount": _controller.text.trim(),
                                "data": {"uuid": id}
                              };

                              print(data);

                              final headers = {
                                'Content-Type': "application/json"
                              };
                              try {
                                final res = await http.post(
                                  Uri.parse(url),
                                  body: json.encode(data),
                                  headers: headers,
                                );

                                final datac = res.body;

                                final decoded = json.decode(datac);

                                final paymentUrl =
                                    decoded['data']['result']['url'];
                                print(paymentUrl);

                                if (context.mounted) {
                                  context.pop();
                                }

                                ref
                                    .read(urlstateProvider.notifier)
                                    .setValue(paymentUrl);

                                if (kIsWeb) {
                                  _launchUrl(paymentUrl);
                                } else {
                                  context.pushNamed(
                                      RouteNameConfig.deposit_screen);

                                  ref
                                      .read(amountFieldValidatorStateProvider
                                          .notifier)
                                      .toggleOff();
                                  ref
                                      .read(
                                          amountValidatorStateProvider.notifier)
                                      .toggleOff();
                                }
                              } on HttpException catch (e) {
                                print(e.message);

                                if (context.mounted) {
                                  context.pop();
                                }
                              }
                            }
                          : null,
                      // color: ,

                      color: isValid
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      outlineColor: isValid
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      textColor: isValid
                          ? Colors.white
                          : Theme.of(context).colorScheme.secondary,
                      description: 'Fund Wallet',
                    );
                  },
                ),
                Gap(60.h)
              ],
            ))
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

class DepositScreenPage extends ConsumerStatefulWidget {
  final String url;
  const DepositScreenPage({super.key, this.url = 'https://flutter.dev'});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DepositScreenPageState();
}

class _DepositScreenPageState extends ConsumerState<DepositScreenPage> {
  late final WebViewController _controller;

  final PlatformWebViewController _webController = PlatformWebViewController(
    const PlatformWebViewControllerCreationParams(),
  )..loadRequest(
      LoadRequestParams(
        uri: Uri.parse('https://flutter.dev'),
      ),
    );

  @override
  void initState() {
    super.initState();

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url == ('https://example.com/return') ||
                request.url == ('https://example.com/success')) {
              debugPrint('blocking navigation to ${request.url}');

              ref.refresh(userFutureProvider(context));

              context.pop();
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.url));

    // setBackgroundColor is not currently supported on macOS.
    if (kIsWeb || !Platform.isMacOS) {
      controller.setBackgroundColor(const Color(0x80000000));
    }

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () async {
            ref.refresh(userFutureProvider(context));
            await _controller.goBack();
            context.pop();
          },
          child: const Icon(Icons.cancel_outlined),
        ),
        title: Text(Uri.parse(widget.url).host),
      ),
      body: kIsWeb
          ? PlatformWebViewWidget(
              PlatformWebViewWidgetCreationParams(controller: _webController),
            ).build(context)
          : WebViewWidget(controller: _controller),
    );
  }
}
