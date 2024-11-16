part of 'extracurricular_bloc.dart';

sealed class ExtracurricularEvent extends Equatable {
  const ExtracurricularEvent();

  @override
  List<Object> get props => [];
}

final class InitialExtracurricular extends ExtracurricularEvent {}

final class GetExtracurricular extends ExtracurricularEvent {}

final class AddExtracurricular extends ExtracurricularEvent {
  final String name;
  final String description;
  final String schedule;
  final String image;

  const AddExtracurricular(
    this.name,
    this.description,
    this.schedule,
    this.image,
  );
}

final class UpdateExtracurricular extends ExtracurricularEvent {
  final String id;
  final String name;
  final String description;
  final String schedule;
  final String image;
  final String baseName;

  const UpdateExtracurricular(
    this.id,
    this.name,
    this.description,
    this.schedule,
    this.image,
    this.baseName,
  );
}

final class DeleteExtracurricular extends ExtracurricularEvent {
  final String id;

  const DeleteExtracurricular(this.id);
}
