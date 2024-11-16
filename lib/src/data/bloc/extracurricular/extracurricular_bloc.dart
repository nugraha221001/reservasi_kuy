import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/extracurricular_model.dart';
import '../../repositories/repositories.dart';

part 'extracurricular_event.dart';

part 'extracurricular_state.dart';

class ExtracurricularBloc extends Bloc<ExtracurricularEvent, ExtracurricularState> {
  Repositories repositories;

  ExtracurricularBloc({required this.repositories}) : super(ExtracurricularInitial()) {
    on<InitialExtracurricular>(_initialExschool);
    on<GetExtracurricular>(_getExschool);
    on<AddExtracurricular>(_addExschool);
    on<UpdateExtracurricular>(_updateExschool);
    on<DeleteExtracurricular>(_deleteExschool);
  }

  _initialExschool(InitialExtracurricular event, Emitter<ExtracurricularState> emit) {}

  _getExschool(GetExtracurricular event, Emitter<ExtracurricularState> emit) async {
    emit(ExtracurricularLoading());
    try {
      final agency = await _getAgency();
      final exschools = await repositories.exschool.getExschoolByAgency(agency);
      if (repositories.exschool.statusCode == "200") {
        emit(ExtracurricularGetSuccess(exschools));
      } else {
        emit(ExtracurricularGetFailed());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///menambahkan exschool
  _addExschool(AddExtracurricular event, Emitter<ExtracurricularState> emit) async {
    emit(ExtracurricularLoading());
    try {
      final agency = await _getAgency();
      await repositories.exschool.addExcur(
        event.name,
        event.description,
        event.schedule,
        event.image,
        agency,
      );

      if (repositories.exschool.statusCode == "200") {
        emit(ExtracurricularAddSuccess());
        add(GetExtracurricular());
      }
      {
        emit(ExtracurricularAddFailed(repositories.exschool.error));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Update/edit Exschool
  _updateExschool(UpdateExtracurricular event, Emitter<ExtracurricularState> emit) async {
    emit(ExtracurricularLoading());
    try {
      final agency = await _getAgency();
      await repositories.exschool.updateExschool(
        event.id,
        event.name,
        event.description,
        event.schedule,
        event.image,
        agency,
        event.baseName,
      );

      if (repositories.exschool.statusCode == "200") {
        emit(ExtracurricularUpdateSuccess());
        add(GetExtracurricular());
      }
      {
        emit(ExtracurricularUpdateFailed(repositories.exschool.error));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// menghapus exschool
  _deleteExschool(DeleteExtracurricular event, Emitter<ExtracurricularState> emit) async {
    emit(ExtracurricularLoading());
    try {
      await repositories.exschool.deleteExschool(event.id);
      if (repositories.exschool.statusCode == "200") {
        emit(ExtracurricularDeleteSuccess());
        add(GetExtracurricular());
      } else {
        emit(ExtracurricularDeleteFailed());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Get Agency
  _getAgency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("agency");
  }
}
