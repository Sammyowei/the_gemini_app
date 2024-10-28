import 'package:country_picker/country_picker.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';
import 'package:the_gemini_app/src/presentation/presentation.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/country_state_notifier_provider.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/number_state_notifier_provider.dart';

import '../../widgets/gemini/gemini_app_widget.dart';

class DocumentVerification extends StatefulWidget {
  const DocumentVerification({super.key});

  @override
  State<DocumentVerification> createState() => _DocumentVerificationState();
}

class _DocumentVerificationState extends State<DocumentVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const GeminiAppWidget(),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Submit documents",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.h),
              Text(
                'We are required by law to verify your identity by collecting  your ID and selfie.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Gap(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Country of residence',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      height: 10.h,
                    ),
                    _countryPicker(context),
                    Gap(25.h),
                    Text(
                      'Choose a verification method',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Gap(10.h),
                    _documentPicker(context,
                        value: 1,
                        documentType: 'National ID Card',
                        icon: Icons.account_box),
                    Gap(5.h),
                    Gap(10.h),
                    _documentPicker(context,
                        value: 2,
                        documentType: 'Passport',
                        icon: Icons.account_box),
                    Gap(5.h),
                    Gap(10.h),
                    _documentPicker(context,
                        value: 3,
                        documentType: 'Driver\' Lisence',
                        icon: Icons.account_box),
                    Gap(5.h),
                    Gap(MediaQuery.sizeOf(context).height * .13.h),
                    Consumer(
                      builder: (context, ref, child) {
                        final country = ref.watch(countryStateNotifierProvider);
                        return CustomButton(
                          onTap: (country == null)
                              ? null
                              : () {
                                  // context.pushNamed(RouteNameConfig
                                  //     .VerificationCaptureScreen);
                                },
                          size: Size(MediaQuery.sizeOf(context).width, 50),
                          color: (country == null)
                              ? Theme.of(context).colorScheme.outline
                              : Theme.of(context).colorScheme.primary,
                          outlineColor: (country == null)
                              ? Theme.of(context).colorScheme.outline
                              : Theme.of(context).colorScheme.primary,
                          description: "Continue",
                          textColor: (country != null)
                              ? Theme.of(context).colorScheme.surface
                              : Theme.of(context).colorScheme.secondary,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _documentPicker(
  BuildContext context, {
  int value = 2,
  String documentType = 'Passport',
  IconData icon = Icons.card_giftcard,
}) {
  return Consumer(
    builder: (context, ref, child) {
      final stateValue = ref.watch(verificationStateNotifierProvider);
      return Container(
        width: MediaQuery.sizeOf(context).width,
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.r),
          ),
          color: Theme.of(context).colorScheme.surface,
          shadows: [
            BoxShadow(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              offset: const Offset(.5, .5),
              spreadRadius: 2,
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: (stateValue == value)
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
            ),
            Gap(5.w),
            Container(
              height: 30,
              width: 1,
              color: Theme.of(context).colorScheme.secondary,
            ),
            Gap(5.w),
            Text(
              documentType,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Radio(
                  value: value,
                  groupValue: stateValue,
                  onChanged: (value) {
                    ref
                        .read(verificationStateNotifierProvider.notifier)
                        .setVerificationMethod(value!);
                  },
                )
              ],
            ))
          ],
        ),
      );
    },
  );
}

Widget _countryPicker(BuildContext context) {
  return Consumer(
    builder: (context, ref, child) {
      final country = ref.watch(countryStateNotifierProvider);
      return GestureDetector(
        onTap: () => showCountryPicker(
          context: context,
          onSelect: (value) {
            ref
                .read(countryStateNotifierProvider.notifier)
                .chooseCountry(value);
          },
          countryListTheme: CountryListThemeData(
            backgroundColor: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(10.r),
            bottomSheetHeight: MediaQuery.sizeOf(context).height * .6,
          ),
          useSafeArea: true,
          moveAlongWithKeyboard: true,
          showSearch: false,
        ),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
              color: Theme.of(context).colorScheme.surface,
              shadows: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                  offset: const Offset(.5, .5),
                  spreadRadius: 2,
                  blurRadius: 2,
                )
              ]),
          child: (country == null)
              ? Row(
                  children: [
                    Text(
                      "Select your country",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.arrow_drop_down_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 18.h,
                        ),
                      ],
                    ))
                  ],
                )
              : Row(
                  children: [
                    Text(
                      country.flagEmoji,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 20.sp,
                          ),
                    ),
                    Gap(5.h),
                    Container(
                      height: 30,
                      width: 1.3,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    Gap(5.h),
                    Text(
                      country.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.arrow_drop_down_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 18.h,
                        ),
                      ],
                    ))
                  ],
                ),
        ),
      );
    },
  );
}
