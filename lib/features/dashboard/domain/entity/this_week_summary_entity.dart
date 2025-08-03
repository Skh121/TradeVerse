import 'package:equatable/equatable.dart';

class ThisWeekSummaryEntity extends Equatable {
  final int dayIndex;
  final double pnl;
  final bool isProfit;

  const ThisWeekSummaryEntity({
    required this.dayIndex,
    required this.pnl,
    required this.isProfit,
  });

  @override
  List<Object?> get props => [dayIndex, pnl, isProfit];
}
