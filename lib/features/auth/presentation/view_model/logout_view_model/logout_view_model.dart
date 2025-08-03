import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradeverse/features/auth/domain/use_case/logout_use_case.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutViewModel extends Bloc<LogoutEvent, LogoutState> {
  final LogoutUseCase logoutUseCase;

  LogoutViewModel({required this.logoutUseCase}) : super(LogoutInitial()) {
    on<PerformLogout>((event, emit) async {
      emit(LogoutLoading());
      try {
        await logoutUseCase();
        emit(LogoutSuccess());
      } catch (e) {
        emit(LogoutFailure("Failed to logout. Please try again."));
      }
    });
  }
}
