import "package:equatable/equatable.dart";

abstract class SendEvent extends Equatable {
  const SendEvent();
  @override
  List<Object> get props => [];
}

class SendRecipientSearched extends SendEvent {
  final String identifier;
  const SendRecipientSearched(this.identifier);
  @override
  List<Object> get props => [identifier];
}

class SendSimulationRequested extends SendEvent {
  final double amount;
  final String sourceChannel;
  final String destinationChannel;

  const SendSimulationRequested({
    required this.amount,
    required this.sourceChannel,
    required this.destinationChannel,
  });

  @override
  List<Object> get props => [amount, sourceChannel, destinationChannel];
}

class SendQuoteRequested extends SendEvent {
  final String recipientIdentifier;
  final String? recipientName;
  final double amount;
  final String sourceChannel;
  final String destinationChannel;

  const SendQuoteRequested({
    required this.recipientIdentifier,
    this.recipientName,
    required this.amount,
    required this.sourceChannel,
    required this.destinationChannel,
  });

  @override
  List<Object> get props => [
    recipientIdentifier,
    amount,
    sourceChannel,
    destinationChannel,
  ];
}

class SendConfirmRequested extends SendEvent {
  final String quoteId;
  const SendConfirmRequested(this.quoteId);

  @override
  List<Object> get props => [quoteId];
}

class SendReset extends SendEvent {}
