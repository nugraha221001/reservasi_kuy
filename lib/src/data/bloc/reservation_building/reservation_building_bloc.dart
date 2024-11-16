import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/building_model.dart';
import '../../repositories/repositories.dart';

part 'reservation_building_event.dart';

part 'reservation_building_state.dart';

class ReservationBuildingBloc
    extends Bloc<ReservationBuildingEvent, ReservationBuildingState> {
  Repositories repositories;

  ReservationBuildingBloc({required this.repositories})
      : super(ReservationBuildingInitial()) {
    on<InitialBuildingAvail>(_initialBuildingAvail);
    on<GetBuildingAvail>(_getBuildingAvail);
  }

  _initialBuildingAvail(
      InitialBuildingAvail event, Emitter<ReservationBuildingState> emit) {
    emit(ResBuInitial());
  }

  _getBuildingAvail(
      GetBuildingAvail event, Emitter<ReservationBuildingState> emit) async {
    emit(ResBuLoading());
    try {
      final agency = await _getAgency();
      final buildings =
          await repositories.building.getBuildingAvailable(agency);
      if (repositories.building.statusCode == "200") {
        emit(ResBuGetSuccess(buildings));
      } else {
        emit(ResBuGetFailed());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  _getAgency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("agency");
  }
}
