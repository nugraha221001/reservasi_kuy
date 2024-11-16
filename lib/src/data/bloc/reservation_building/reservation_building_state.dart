part of 'reservation_building_bloc.dart';

sealed class ReservationBuildingState extends Equatable {
  const ReservationBuildingState();
}

final class ReservationBuildingInitial extends ReservationBuildingState {
  @override
  List<Object> get props => [];
}

class ResBuGetSuccess extends ReservationBuildingState {
  final List<BuildingModel> buildings;

  const ResBuGetSuccess(this.buildings);

  @override
  List<Object> get props => [buildings];
}

final class ResBuGetFailed extends ReservationBuildingState {
  @override
  List<Object> get props => [];
}

final class ResBuLoading extends ReservationBuildingState {
  @override
  List<Object> get props => [];
}

final class ResBuInitial extends ReservationBuildingState {
  @override
  List<Object> get props => [];
}
