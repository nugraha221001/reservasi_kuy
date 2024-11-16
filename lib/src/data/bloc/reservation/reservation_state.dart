part of 'reservation_bloc.dart';

abstract class ReservationState extends Equatable {
  const ReservationState();
}

class ReservationInitial extends ReservationState {
  @override
  List<Object> get props => [];
}

class ReservationLoading extends ReservationState {
  @override
  List<Object> get props => [];
}

class ReservationGetSuccess extends ReservationState {
  final List<ReservationModel> reservations;

  const ReservationGetSuccess(this.reservations);

  @override
  List<Object> get props => [];
}

class ReservationBooked extends ReservationState {
  final List<ReservationModel> booked;

  const ReservationBooked(this.booked);

  @override
  List<Object> get props => [];
}

class ReservationNoBooked extends ReservationState {
  @override
  List<Object> get props => [];
}


class ReservationGetFailed extends ReservationState {
  @override
  List<Object> get props => [];
}

class ReservationCreateSuccess extends ReservationState {
  @override
  List<Object> get props => [];
}

class ReservationCreateFailed extends ReservationState {
  @override
  List<Object> get props => [];
}

class ReservationDeleteSuccess extends ReservationState {
  @override
  List<Object> get props => [];
}

class ReservationDeleteFailed extends ReservationState {
  @override
  List<Object> get props => [];
}

class ReservationUpdateSuccess extends ReservationState {
  @override
  List<Object> get props => [];
}

class ReservationUpdateFailed extends ReservationState {
  @override
  List<Object> get props => [];
}
