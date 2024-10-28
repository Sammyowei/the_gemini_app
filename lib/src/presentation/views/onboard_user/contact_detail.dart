import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;
import 'package:the_gemini_app/src/data/models/user.dart';
import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';
import 'package:the_gemini_app/src/presentation/widgets/supabase/supabase_inherited_widget.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/country_state_notifier_provider.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/user_state_notifier_provider.dart';

import '../../../providers/state_notifier_provider/boolean_state_notifier_provider.dart';
import '../../presentation.dart';
import '../../widgets/gemini/gemini_app_widget.dart';

class ContactDetailScreen extends ConsumerStatefulWidget {
  const ContactDetailScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ContactDetailScreenState();
}

class _ContactDetailScreenState extends ConsumerState<ContactDetailScreen> {
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    _addressController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _validatePhoneNumber(String? value) {
    if (value!.isEmpty) {
      ref.read(phoneNumberFieldValidatorStateProvider.notifier).toggleOff();
    } else {
      ref.read(phoneNumberFieldValidatorStateProvider.notifier).toggleOn();

      if (value.length < 7) {
        ref.read(phoneNumberValidatorStateProvider.notifier).toggleOff();
      } else {
        ref.read(phoneNumberValidatorStateProvider.notifier).toggleOn();
      }
    }
  }

  void _validateAddress(String? value) {
    if (value!.isEmpty) {
      ref.read(addressFieldValidatorStateProvider.notifier).toggleOff();
    } else {
      ref.read(addressFieldValidatorStateProvider.notifier).toggleOn();

      if (value.length < 7) {
        ref.read(addressValidatorStateProvider.notifier).toggleOff();
      } else {
        ref.read(addressValidatorStateProvider.notifier).toggleOn();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const GeminiAppWidget(),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Add Your Contact Information",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                'Let’s Stay Connected! Add Your Contact Details.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Gap(30.h),
              _countryPicker(context),
              const Gap(20),
              Consumer(
                builder: (context, ref, child) {
                  final isFieldValid =
                      ref.watch(phoneNumberFieldValidatorStateProvider);

                  final isValid = ref.watch(phoneNumberValidatorStateProvider);
                  final country = ref.watch(countryStateNotifierProvider);

                  return CustomTextField(
                    hintText: 'Phone number ',
                    onChanged: _validatePhoneNumber,
                    controller: _phoneNumberController,
                    sulfixIcon: isFieldValid
                        ? isValid
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
                    prefixIcon: GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          onSelect: (value) {
                            ref
                                .read(countryStateNotifierProvider.notifier)
                                .chooseCountry(value);
                          },
                          countryListTheme: CountryListThemeData(
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(10.r),
                            bottomSheetHeight:
                                MediaQuery.sizeOf(context).height * .65,
                          ),
                        );
                      },
                      child: country == null
                          ? const Icon(
                              Icons.arrow_drop_down,
                            )
                          : SizedBox(
                              width: 25.w,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Gap(5.w),
                                  Text(
                                    '+${country.phoneCode}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )
                                ],
                              ),
                            ),
                    ),
                  );
                },
              ),
              Gap(20.h),
              Consumer(
                builder: (context, ref, child) {
                  final isFieldValid =
                      ref.watch(addressFieldValidatorStateProvider);

                  final isValid = ref.watch(addressValidatorStateProvider);
                  return CustomTextField(
                    hintText: 'Address',
                    controller: _addressController,
                    onChanged: _validateAddress,
                    prefixIcon: Icon(
                      Icons.home_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 18.h,
                    ),
                    sulfixIcon: isFieldValid
                        ? isValid
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
                  );
                },
              ),
              Gap(20.h),
              Consumer(
                builder: (context, ref, child) {
                  final isPhoneValid =
                      ref.watch(phoneNumberValidatorStateProvider);

                  final isAddressValid =
                      ref.watch(addressValidatorStateProvider);

                  final isValid = (isPhoneValid && isAddressValid);
                  return CustomButton(
                    onTap: isValid
                        ? () async {
                            final country = ref
                                .read(countryStateNotifierProvider.notifier)
                                .getCountry();

                            final phoneNumber =
                                "${country?.phoneCode}${_phoneNumberController.text.trim()}";
                            final user0 =
                                ref.read(userProvider.notifier).getUser();

                            final countryName =
                                country!.displayName.split(' ').first;

                            final isCountryPresent =
                                _addressController.text.endsWith(countryName);

                            String address;

                            if (!isCountryPresent) {
                              var splitAddress =
                                  _addressController.text.trim().split(" ");
                              splitAddress.add(countryName);
                              address = splitAddress.join(' ');
                            } else {
                              address = _addressController.text.trim();
                            }

                            print(address);

                            final user = User(
                                uid: MySupabaseConfig.of(context)
                                    .supabase
                                    .client
                                    .auth
                                    .currentUser
                                    ?.id,
                                firstName: user0!.firstName,
                                lastName: user0.lastName,
                                email: user0.email,
                                address: address,
                                phoneNumber: phoneNumber);

                            print(user.toJson());

                            try {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog.adaptive(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.r),
                                    ),
                                    content: const Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    ),
                                  );
                                },
                              );

                              await MySupabaseConfig.of(context)
                                  .supabase
                                  .client
                                  .from('users_table')
                                  .insert(user.toJson());

                              if (context.mounted) {
                                context.pop();
                                context.goNamed(RouteNameConfig.home_page);
                              }
                            } on PostgrestException catch (e) {
                              print(e.details);
                              if (context.mounted) {
                                context.pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      e.message,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                        : null,
                    size: Size(MediaQuery.sizeOf(context).width, 50),
                    color: isValid
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    outlineColor: isValid
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    description: 'Continue',
                    textColor: isValid
                        ? Colors.white
                        : Theme.of(context).colorScheme.secondary,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
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
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              color: Theme.of(context).colorScheme.surface,
              shadows: const [
                // BoxShadow(
                //   color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                //   offset: const Offset(.5, .5),
                //   spreadRadius: 2,
                //   blurRadius: 2,
                // )
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

class PhoneNumberFormatter extends TextInputFormatter {
  final String countryCode;

  PhoneNumberFormatter(this.countryCode);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Basic formatting logic based on country code
    String formattedNumber = newValue.text;

    // Example for US phone number formatting
    if (countryCode == 'US') {
      if (formattedNumber.length >= 3) {
        formattedNumber =
            '(${formattedNumber.substring(0, 3)}) ${formattedNumber.substring(3)}';
      }
      if (formattedNumber.length > 9) {
        formattedNumber =
            '${formattedNumber.substring(0, 9)}-${formattedNumber.substring(9)}';
      }
    }

    // Return the formatted value
    return TextEditingValue(
      text: formattedNumber,
      selection: TextSelection.collapsed(offset: formattedNumber.length),
    );
  }
}
