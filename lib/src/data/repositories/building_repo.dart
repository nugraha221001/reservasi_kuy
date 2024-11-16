part of 'repositories.dart';

class BuildingRepo {
  late String statusCode;
  late String error;

  //This for superAdmin but add agency for the detail
  getBuilding() async {
    statusCode = "";
    try {
      QuerySnapshot resultBuilding =
          await Repositories().db.collection("buildings").get();
      if (resultBuilding.docs.isNotEmpty) {
        statusCode = "200";
        final List<BuildingModel> buildings =
            resultBuilding.docs.map((e) => BuildingModel.fromJson(e)).toList();
        return buildings;
      } else {
        statusCode = "200";
        final List<BuildingModel> buildings = [];
        return buildings;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// mendapatkan info gedung sesuai instansi
  getBuildingByAgency(String agency) async {
    statusCode = "";
    try {
      QuerySnapshot resultBuilding = await Repositories()
          .db
          .collection("buildings")
          .where("agency", isEqualTo: agency)
          .get();
      if (resultBuilding.docs.isNotEmpty) {
        statusCode = "200";
        final List<BuildingModel> buildings =
            resultBuilding.docs.map((e) => BuildingModel.fromJson(e)).toList();
        return buildings;
      } else {
        statusCode = "200";
        final List<BuildingModel> buildings = [];
        return buildings;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// menambahkan building
  addBuilding(
    String name,
    String description,
    String facility,
    int capacity,
    String rule,
    String image,
    String agency,
  ) async {
    statusCode = "";
    error = "";

    final parsedBuildingName = ParsingString().removeMultiSpace(name);
    try {
      /// check if building already exist
      QuerySnapshot resultBuilding = await Repositories()
          .db
          .collection("buildings")
          .where("agency", isEqualTo: agency)
          .get();
      final List<BuildingModel> listBuilding = resultBuilding.docs
          .map(
            (e) => BuildingModel.fromJson(e),
          )
          .toList();
      final buildingNameIsExist = listBuilding
          .where(
            (element) =>
                element.name?.toLowerCase() == parsedBuildingName.toLowerCase(),
          )
          .toList();
      if (buildingNameIsExist.isNotEmpty) {
        /// building is exist
        error = "Gedung sudah ada";
      } else {
        await Repositories().db.collection("buildings").add({
          "id": "",
          "name": parsedBuildingName,
          "description": description,
          "facility": facility,
          "capacity": capacity,
          "rule": rule,
          "image": image,
          "agency": agency,
          "status": "Tersedia",
        }).then(
          (value) {
            Repositories()
                .db
                .collection("buildings")
                .doc(value.id)
                .update({"id": value.id});
          },
        );
        statusCode = "200";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Mengupdate atau mengedit building
  updateBuilding(
    String id,
    String name,
    String description,
    String facility,
    int capacity,
    String rule,
    String image,
    String agency,
    String baseName,
    String status,
  ) async {
    statusCode = "";
    error = "";
    final parsedBuildingName = ParsingString().removeMultiSpace(name);
    final parsedBuildingBaseName = ParsingString().removeMultiSpace(baseName);

    try {
      /// check if building already exist
      QuerySnapshot resultBuilding = await Repositories()
          .db
          .collection("buildings")
          .where("agency", isEqualTo: agency)
          .get();
      final List<BuildingModel> listBuilding = resultBuilding.docs
          .map(
            (e) => BuildingModel.fromJson(e),
          )
          .toList();
      listBuilding.removeWhere(
        (element) =>
            element.name?.toLowerCase() == parsedBuildingBaseName.toLowerCase(),
      );
      final buildingNameIsExist = listBuilding
          .where(
            (element) =>
                element.name?.toLowerCase() == parsedBuildingName.toLowerCase(),
          )
          .toList();
      if (buildingNameIsExist.isNotEmpty) {
        /// building is exist
        error = "Gedung sudah ada, coba yang lain";
      } else {
        await Repositories().db.collection("buildings").doc(id).update({
          "name": parsedBuildingName,
          "description": description,
          "facility": facility,
          "capacity": capacity,
          "rule": rule,
          "image": image,
          "status": status,
        });
        statusCode = "200";
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Mendapatkan info gedung yang tersedia pada halaman reservasi
  getBuildingAvailable(String agency) async {
    statusCode = "";
    try {
      QuerySnapshot resultBuilding = await Repositories()
          .db
          .collection("buildings")
          .where("agency", isEqualTo: agency)
          .get();
      if (resultBuilding.docs.isNotEmpty) {
        statusCode = "200";
        final List<BuildingModel> buildings =
            resultBuilding.docs.map((e) => BuildingModel.fromJson(e)).toList();

        final buildingAvail =
            buildings.where((element) => element.status == "Tersedia").toList();
        return buildingAvail;
      } else {
        statusCode = "200";
        final List<BuildingModel> buildings = [];
        return buildings;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Mengubah status building menjadi tidak tersedia
  changeStatusBuilding(String name) async {
    statusCode = "";
    error = "";
    try {
      final resultBuilding = await Repositories()
          .db
          .collection("buildings")
          .where("name", isEqualTo: name)
          .get();
      if (resultBuilding.docs.isNotEmpty) {
        final building = resultBuilding.docs.first;
        await Repositories()
            .db
            .collection("buildings")
            .doc(building.id)
            .update({
          "status": "Tidak Tersedia",
        });
        statusCode = "200";
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Menghapus building
  deleteBuilding(String id) async {
    statusCode = "";
    try {
      await Repositories().db.collection("buildings").doc(id).delete();
      statusCode = "200";
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }
}
