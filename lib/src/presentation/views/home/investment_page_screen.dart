import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InvestmentScreen extends ConsumerStatefulWidget {
  final String investmentType;
  const InvestmentScreen({super.key, this.investmentType = 'crypto'});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InvestmentScreenState();
}

class _InvestmentScreenState extends ConsumerState<InvestmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          return const Center(
            child: Text('Deposit Succful'),
          );
        },
      ),
    );
  }
}
