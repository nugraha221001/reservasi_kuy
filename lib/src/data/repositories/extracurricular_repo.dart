part of 'repositories.dart';

class ExschoolRepo {
  late String statusCode;
  late String error;

  getExschoolByAgency(String agency) async {
    statusCode = "";
    try {
      QuerySnapshot resultExschool = await Repositories()
          .db
          .collection("extracurriculars")
          .where("agency", isEqualTo: agency)
          .get();
      if (resultExschool.docs.isNotEmpty) {
        statusCode = "200";
        final List<ExtracurricularModel> extracurriculars = resultExschool.docs
            .map((e) => ExtracurricularModel.fromJson(e))
            .toList();
        return extracurriculars;
      } else {
        statusCode = "200";
        final List<ExtracurricularModel> extracurriculars = [];
        return extracurriculars;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// menambahkan exschool
  addExcur(
    String name,
    String description,
    String schedule,
    String image,
    String agency,
  ) async {
    statusCode = "";
    error = "";

    final parsedExcurName = ParsingString().removeMultiSpace(name);
    try {
      /// check if excur already exist
      QuerySnapshot resultExcur = await Repositories()
          .db
          .collection("extracurriculars")
          .where("agency", isEqualTo: agency)
          .get();
      final List<ExtracurricularModel> listExcur = resultExcur.docs
          .map(
            (e) => ExtracurricularModel.fromJson(e),
          )
          .toList();
      final excurNameIsExist = listExcur
          .where(
            (element) =>
                element.name?.toLowerCase() == parsedExcurName.toLowerCase(),
          )
          .toList();
      if (excurNameIsExist.isNotEmpty) {
        /// excur is exist
        error = "Ekstrakurikuler sudah ada";
      } else {
        await Repositories().db.collection("extracurriculars").add({
          "id": "",
          "name": name,
          "description": description,
          "schedule": schedule,
          "image": image,
          "agency": agency,
        }).then(
          (value) {
            Repositories()
                .db
                .collection("extracurriculars")
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

  ///Menghapus exschool
  deleteExschool(String id) async {
    statusCode = "";
    try {
      await Repositories().db.collection("extracurriculars").doc(id).delete();
      statusCode = "200";
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Mengupdate atau mengedit exschool
  updateExschool(
    String id,
    String name,
    String description,
    String schedule,
    String image,
    String agency,
    String baseName,
  ) async {
    statusCode = "";
    error = "";

    final parsedExcurName = ParsingString().removeMultiSpace(name);
    final parsedExcurBaseName = ParsingString().removeMultiSpace(baseName);
    try {
      /// check if excur already exist
      QuerySnapshot resultExcur = await Repositories()
          .db
          .collection("extracurriculars")
          .where("agency", isEqualTo: agency)
          .get();
      final List<ExtracurricularModel> listExcur = resultExcur.docs
          .map(
            (e) => ExtracurricularModel.fromJson(e),
          )
          .toList();
      listExcur.removeWhere(
        (element) =>
            element.name?.toLowerCase() == parsedExcurBaseName.toLowerCase(),
      );
      final excurNameIsExist = listExcur
          .where(
            (element) =>
                element.name?.toLowerCase() == parsedExcurName.toLowerCase(),
          )
          .toList();
      if (excurNameIsExist.isNotEmpty) {
        /// excur is exist
        error = "Ekskul sudah ada, coba yang lain";
      } else {
        await Repositories().db.collection("extracurriculars").doc(id).update({
          "name": name,
          "description": description,
          "schedule": schedule,
          "image": image,
        });
        statusCode = "200";
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
