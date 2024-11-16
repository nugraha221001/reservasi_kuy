part of 'building_bloc.dart';

abstract class BuildingEvent extends Equatable {
  const BuildingEvent();

  @override
  List<Object> get props => [];
}

class InitialBuilding extends BuildingEvent {}

class GetBuildingSuperAdmin extends BuildingEvent {}

class GetBuildingByAgency extends BuildingEvent {}



class AddBuilding extends BuildingEvent {
  final String name;
  final String description;
  final String facility;
  final int capacity;
  final String rule;
  final String image;

  const AddBuilding(
    this.name,
    this.description,
    this.facility,
    this.capacity,
    this.rule,
    this.image,
  );
}

class DeleteBuilding extends BuildingEvent {
  final String id;

  const DeleteBuilding(this.id);
}

class ChangeStatusBuilding extends BuildingEvent {
  final String name;
  final String dateEnd;

  const ChangeStatusBuilding(this.name, this.dateEnd);
}

class UpdateBuilding extends BuildingEvent {
  final String id;
  final String name;
  final String description;
  final String facility;
  final int capacity;
  final String rule;
  final String image;
  final String baseName;
  final String status;

  const UpdateBuilding(
    this.id,
    this.name,
    this.description,
    this.facility,
    this.capacity,
    this.rule,
    this.image,
    this.baseName,
    this.status,
  );
}
