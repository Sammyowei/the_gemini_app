import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:the_gemini_app/src/providers/state_notifier_provider/user_state_notifier_provider.dart';

class INvestmentDetailPage extends ConsumerStatefulWidget {
  const INvestmentDetailPage({super.key, this.investmentID = ''});

  final String investmentID;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _INvestmentDetailPageState();
}

class _INvestmentDetailPageState extends ConsumerState<INvestmentDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final user = ref.watch(userModelsProvider);

        final investments = user?.investment;
        if (investments == null) {
          return Container();
        }

        final investment = investments
            .where((element) => element.id == widget.investmentID)
            .first;

        final investmentTypes = user?.investmentType;

        final investmentType = investmentTypes
            ?.where(
              (element) => element.id == investment.investmentTypeId,
            )
            .first;
        print(investment.toJson());

        print(investmentType?.toJson());

        return Container(
          padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 15.w),
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            children: [
              Text(
                'Investment Details',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Gap(30.h),
              Row(
                children: [
                  Text(
                    'Investment name:\n${investmentType?.name}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                ],
              ),
              Gap(20.h),
              Row(
                children: [
                  Text(
                    'Ivestment date:\n${DateFormat().format(investment.createdAt)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                ],
              ),
              Gap(20.h),
              Row(
                children: [
                  Text(
                    'Maturity date:\n${DateFormat().format(investment.maturityDate)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                ],
              ),
              Gap(20.h),
              Row(
                children: [
                  Text(
                    'Investment amount:\n${NumberFormat.currency(name: 'USD', locale: 'En_US', symbol: '\$').format(investment.amount)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                ],
              ),
              Gap(20.h),
              Row(
                children: [
                  Text(
                    'Expected Return:\n${investmentType?.expectedReturn}%',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                ],
              ),
              Gap(20.h),
              Row(
                children: [
                  Text(
                    'Payout amount:\n${NumberFormat.currency(name: 'USD', locale: 'En_US', symbol: '\$').format(investment.amount * (investmentType!.expectedReturn / 100))}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
