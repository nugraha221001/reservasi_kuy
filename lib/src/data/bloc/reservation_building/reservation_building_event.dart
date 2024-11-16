part of 'reservation_building_bloc.dart';

sealed class ReservationBuildingEvent extends Equatable {
  const ReservationBuildingEvent();

  @override
  List<Object> get props => [];
}

final class GetBuildingAvail extends ReservationBuildingEvent {}

final class InitialBuildingAvail extends ReservationBuildingEvent {}
