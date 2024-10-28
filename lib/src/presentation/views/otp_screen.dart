import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_gemini_app/src/data/data.dart';
import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';
import 'package:the_gemini_app/src/presentation/presentation.dart';
import 'package:the_gemini_app/src/presentation/utils/presistence/persistence.dart';
import 'package:the_gemini_app/src/presentation/widgets/supabase/supabase_inherited_widget.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/boolean_state_notifier_provider.dart';
import '../widgets/gemini/gemini_app_widget.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, this.email = ''});

  final String email;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late TextEditingController _otpController;

  @override
  void initState() {
    _otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const GeminiAppWidget(),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Please enter the code",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Text(
                'We sent email to ${widget.email}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 20.h),
              SvgPicture.asset(IconConstants.mailIconSvg),
              SizedBox(height: 30.h),
              Consumer(
                builder: (context, ref, child) {
                  return PinCodeTextField(
                    controller: _otpController,
                    onChanged: (value) {
                      if (value.length < 6) {
                        ref.read(otpValidatorProvider.notifier).toggleOff();
                      } else {
                        ref.read(otpValidatorProvider.notifier).toggleOn();
                      }
                    },
                    onCompleted: (value) {},
                    onEditingComplete: () {},
                    onSaved: (newValue) {},
                    onSubmitted: (value) {},
                    appContext: context,
                    length: 6,
                    animationType: AnimationType.fade,
                    autoDismissKeyboard: true,
                    autoFocus: true,
                    autoUnfocus: true,
                    cursorColor: Theme.of(context).colorScheme.primary,
                    keyboardType: TextInputType.number,
                    beforeTextPaste: (text) {
                      if (text is! int) {
                        return false;
                      }
                      return true;
                    },
                    pinTheme: PinTheme(
                      // inactiveColor: Theme.of(context).colorScheme.outline,
                      shape: PinCodeFieldShape.box,

                      selectedColor: Theme.of(context).colorScheme.primary,
                      activeColor:
                          Theme.of(context).colorScheme.primary.withOpacity(.5),

                      inactiveColor: Theme.of(context).colorScheme.outline,
                      // activeBorderWidth: 50.w,
                      borderRadius: BorderRadius.circular(
                        5.r,
                      ),

                      fieldHeight: 50.h,

                      fieldWidth: 50.w,
                    ),
                  );
                },
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't get a mail?",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Gap(5),
                  GestureDetector(
                    onTap: () async {
                      final email = SharedPersistence().get('_email');
                      final auth = await MySupabaseConfig.of(context)
                          .supabase
                          .client
                          .auth
                          .resend(
                            type: OtpType.signup,
                            email: email,
                          );
                    },
                    child: Text(
                      "Send again",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20.h),
              Consumer(
                builder: (context, ref, child) {
                  final otpComplete = ref.watch(otpValidatorProvider);
                  return CustomButton(
                    onTap: !otpComplete
                        ? null
                        : () async {
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
                              final auth = await MySupabaseConfig.of(context)
                                  .supabase
                                  .client
                                  .auth
                                  .verifyOTP(
                                      email: widget.email,
                                      type: OtpType.signup,
                                      token: _otpController.text.trim());
                              if (context.mounted) {
                                context.pop();
                                context.goNamed(RouteNameConfig.onboard_user);
                              }
                            } on AuthException catch (e) {
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
                          },
                    size: Size(
                      MediaQuery.sizeOf(context).width,
                      50,
                    ),
                    color: otpComplete
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    outlineColor: otpComplete
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                    description: "Continue",
                    textColor: otpComplete
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
