import "package:equatable/equatable.dart";
import "package:kinoapay_app/core/errors/app_exception.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/send/domain/entities/transfer_quote.dart";

abstract class SendState extends Equatable {
  const SendState();
  @override
  List<Object?> get props => [];
}

class SendInitial extends SendState {}

class SendLoading extends SendState {}

class SendQuoteReady extends SendState {
  final TransferQuote quote;
  const SendQuoteReady(this.quote);

  @override
  List<Object?> get props => [quote];
}

class SendConfirming extends SendState {}

class SendSuccess extends SendState {
  final Transaction transaction;
  const SendSuccess(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class SendError extends SendState {
  final KinoaException exception;
  const SendError(this.exception);

  @override
  List<Object?> get props => [exception];
}
