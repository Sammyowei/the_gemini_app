import 'package:avatar_plus/avatar_plus.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:the_gemini_app/src/data/models/user_model.dart';

import 'package:the_gemini_app/src/domain/config/routes/route_name_config.dart';
import 'package:the_gemini_app/src/presentation/presentation.dart';
import 'package:the_gemini_app/src/presentation/utils/effects.dart';
import 'package:the_gemini_app/src/presentation/widgets/gemini/gemini_app_widget.dart';
import 'package:the_gemini_app/src/presentation/widgets/supabase/supabase_inherited_widget.dart';
import 'package:the_gemini_app/src/providers/future_providers/user_future_provider.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/number_state_notifier_provider.dart';
import '../../../providers/state_notifier_provider/user_state_notifier_provider.dart';
import 'wallet_page.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: const GeminiAppWidget(),
          elevation: 0,
          leading: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AvatarPlus(
                "Samuelson Owei",
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                context.pushNamed(RouteNameConfig.notification_screen);
              },
              child: Icon(
                Icons.notifications,
                size: 25.h,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Gap(10.w),
          ],
          centerTitle: true,
        ),
        body: Consumer(
          builder: (context, ref, child) {
            final index = ref.watch(bottomNavStateProvider);
            final futureUserData = ref.watch(userFutureProvider(context));

            return futureUserData.when(
              data: (data) {
                if (data != null) {
                  ref.read(userModelsProvider.notifier).setUser(data);
                }
                final body = [
                  const SingleChildScrollView(child: HomeBody()),
                  const SingleChildScrollView(child: WalletBody())
                ];
                return body[index];
              },
              error: (error, stackTrace) {
                return Center(
                  child: Text('Error: ${error.toString()}'),
                );
              },
              loading: () {
                // Create a skeleton version of the UI for loading state
                final skeletonBody = [
                  SingleChildScrollView(
                    child: Skeletonizer(
                      enabled: true,
                      ignoreContainers: false,
                      effect: NewPaintEffect(
                        shimmerColor: Theme.of(context).colorScheme.background,
                        startColor: Theme.of(context).colorScheme.secondary,
                        endColor: Theme.of(context).colorScheme.secondary,
                      ),
                      containersColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.3),
                      child: const HomeBody(),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Skeletonizer(
                      enabled: true,
                      ignoreContainers: false,
                      effect: NewPaintEffect(
                        shimmerColor: Theme.of(context).colorScheme.background,
                        startColor: Theme.of(context).colorScheme.secondary,
                        endColor: Theme.of(context).colorScheme.secondary,
                      ),
                      containersColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.3),
                      child: const WalletBody(),
                    ),
                  ),
                ];
                return skeletonBody[index];
              },
            );
          },
        ),
        bottomNavigationBar: Consumer(
          builder: (context, ref, child) {
            final index = ref.watch(bottomNavStateProvider);
            return BottomNavigationBar(
              currentIndex: index,
              unselectedItemColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(.5),
              selectedItemColor: Theme.of(context).colorScheme.primary,
              type: BottomNavigationBarType.shifting,
              onTap: (value) =>
                  ref.read(bottomNavStateProvider.notifier).setValue(value),
              items: const [
                BottomNavigationBarItem(
                  label: 'Home',
                  icon: Icon(
                    Icons.home_outlined,
                  ),
                ),
                BottomNavigationBarItem(
                  label: 'Wallet',
                  icon: Icon(
                    Icons.wallet_rounded,
                  ),
                )
              ],
            );
          },
        ));
  }
}

class HomeBody extends ConsumerStatefulWidget {
  const HomeBody({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeBodyState();
}

class _HomeBodyState extends ConsumerState<HomeBody> {
  @override
  Widget build(BuildContext context) {
    final userModel = ref.watch(userModelsProvider);

    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your total wealth',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final amount = userModel != null
                            ? getUsdWalletBalance(userModel) +
                                getInvestmentsBalance(userModel) +
                                getInvestmentsBalance(userModel, 'capital') +
                                getInvestmentsBalance(userModel, 'ai/tesla')
                            : 0;

                        final formattedCurrency = NumberFormat.currency(
                          locale: 'en_US',
                          symbol: '\$',
                          decimalDigits: 2,
                        ).format(amount);

                        return Text(
                          formattedCurrency,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: amount > 0
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Theme.of(context).colorScheme.outline,
                              ),
                        );
                      },
                    )
                  ],
                ),
                CustomButton(
                  onTap: () async {
                    context.pushNamed(RouteNameConfig.wallet_page_section);
                  },
                  size: Size(40.w, 40.h),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  widget: Center(
                    child: Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  outlineColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.4),
                ),
              ],
            ),
            Gap(30.h),
            Row(
              children: [
                Text(
                  'Assets',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            Gap(15.h),
            _coolButton(
              context,
              ontap: () {
                context.pushNamed(RouteNameConfig.investment_page,
                    queryParameters: {'id': 'crypto'});
              },
              amount: getInvestmentsBalance(
                userModel,
              ),
              title: 'Crypto Investment',
              color: Theme.of(context).colorScheme.tertiaryContainer,
              icon: Icons.currency_bitcoin_outlined,
            ),
            Gap(10.h),
            _coolButton(
              context,
              ontap: () {
                context.pushNamed(RouteNameConfig.investment_page,
                    queryParameters: {'id': 'capital'});
              },
              amount: getInvestmentsBalance(userModel, 'capital'),
              title: 'Capital Ventures',
              color: Theme.of(context).colorScheme.primaryContainer,
              icon: Icons.currency_exchange_rounded,
            ),
            Gap(10.h),
            _coolButton(
              context,
              ontap: () {
                context.pushNamed(RouteNameConfig.investment_page,
                    queryParameters: {'id': 'ai/tesla'});
              },
              amount: getInvestmentsBalance(userModel, 'ai/tesla'),
              title: 'Smart AI Investment',
              color: Theme.of(context).colorScheme.secondaryContainer,
              icon: Icons.auto_awesome_rounded,
            ),
            Gap(35.h),
            Row(
              children: [
                Text(
                  'Wallets',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            Gap(10.h),
            _coolButton(
              ontap: () =>
                  context.pushNamed(RouteNameConfig.wallet_page_section),
              context,
              amount: userModel != null ? getUsdWalletBalance(userModel) : 0,
              title: 'USD Wallet',
              color: Theme.of(context).colorScheme.secondaryContainer,
              icon: Icons.wallet_rounded,
            ),
            Gap(10.h),
            _coolButton(
              context,
              amount: 0,
              title: 'Crypto Wallet',
              color: Theme.of(context).colorScheme.primaryContainer,
              icon: Icons.wallet_rounded,
            )
          ],
        ),
      ),
    );
  }
}

Widget _coolButton(
  BuildContext context, {
  VoidCallback? ontap,
  IconData? icon,
  String? title,
  Color? color,
  num amount = 100000,
}) {
  return CustomButton(
    onTap: ontap,
    size: Size(MediaQuery.sizeOf(context).width, 89),
    color: Theme.of(context).colorScheme.outline.withOpacity(.6),
    outlineColor: Theme.of(context).colorScheme.outline.withOpacity(.6),
    widget: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width * .69.w,
            child: Row(
              children: [
                Container(
                  height: 45.h,
                  width: 45.w,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: color ??
                        Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: Center(
                    child: Icon(
                      icon ?? Icons.leaderboard_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                Gap(5.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'USD Wallet',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final formattedCurrency = NumberFormat.currency(
                          locale: 'en_US',
                          symbol: '\$',
                          decimalDigits: 2,
                        ).format(amount);

                        return Text(
                          formattedCurrency,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                  color: amount > 0
                                      ? Theme.of(context).colorScheme.onSurface
                                      : Theme.of(context).colorScheme.outline,
                                  fontSize: 20.sp),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_outlined,
            color: Theme.of(context).colorScheme.secondary,
          )
        ],
      ),
    ),
  );
}

class WalletBody extends StatefulWidget {
  const WalletBody({
    super.key,
  });

  @override
  State<WalletBody> createState() => _WalletBodyState();
}

class _WalletBodyState extends State<WalletBody> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wallets',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Gap(10.h),
            Consumer(
              builder: (context, ref, child) {
                final userModel = ref.watch(userModelsProvider);
                return _coolButton(
                  ontap: () =>
                      context.pushNamed(RouteNameConfig.wallet_page_section),
                  context,
                  amount: getUsdWalletBalance(userModel),
                  title: 'USD Wallet',
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  icon: Icons.wallet_rounded,
                );
              },
            ),
            Gap(10.h),
            _coolButton(
              context,
              amount: 0,
              title: 'Crypto Wallet',
              color: Theme.of(context).colorScheme.primaryContainer,
              icon: Icons.wallet_rounded,
            )
          ],
        ),
      ),
    );
  }
}
