import 'package:equatable/equatable.dart';

class RecentTradeEntity extends Equatable {
  final String ticker;
  final String type;
  final String status;
  final double pnl;
  final DateTime date;

  const RecentTradeEntity({
    required this.ticker,
    required this.type,
    required this.status,
    required this.pnl,
    required this.date,
  });

  @override
  List<Object?> get props => [ticker, type, status, pnl, date];
}
