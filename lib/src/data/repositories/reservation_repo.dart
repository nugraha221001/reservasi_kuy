part of 'repositories.dart';

class ReservationRepo {
  late String error;
  late String statusCode;

  /// membuat reservasi
  createReservation(
    String? buildingName,
    String? contactId,
    String? contactName,
    String? contactEmail,
    String? contactPhone,
    String? dateStart,
    String? dateEnd,
    String? dateCreated,
    String? information,
    String? agency,
    String? image,
  ) async {
    statusCode = "";

    try {
      await Repositories().db.collection("reservations").add({
        "id": "",
        "buildingName": buildingName,
        "contactId": contactId,
        "contactName": contactName,
        "contactEmail": contactEmail,
        "contactPhone": contactPhone,
        "dateStart": dateStart,
        "dateEnd": dateEnd,
        "dateCreated": dateCreated,
        "information": information,
        "agency": agency,
        "status": "Menunggu",
        "image": image,
      }).then(
        (value) {
          Repositories()
              .db
              .collection("reservations")
              .doc(value.id)
              .update({"id": value.id});
        },
      );
      statusCode = "200";
    } catch (e) {
      throw Exception(e);
    }
  }

  /// mendapatkan informasi reservasi berdasarkan user
  getReservationForUser(String contactId) async {
    error = "";
    statusCode = "";

    try {
      QuerySnapshot resultReservations = await Repositories()
          .db
          .collection("reservations")
          .where("contactId", isEqualTo: contactId)
          .get();

      if (resultReservations.docs.isNotEmpty) {
        statusCode = "200";
        final List<ReservationModel> reservations = resultReservations.docs
            .map((e) => ReservationModel.fromJson(e))
            .toList();
        final onReservation = reservations
            .where(
              (element) =>
                  element.status == "Menunggu" ||
                  element.status == "Disetujui" ||
                  element.status == "Ditolak",
            )
            .toList();
        return onReservation;
      } else {
        statusCode = "200";
        final List<ReservationModel> reservations = [];
        return reservations;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// membatalkan reservasi
  cancelReservation(String contactId) async {
    error = "";
    statusCode = "";

    try {
      QuerySnapshot resultReservations = await Repositories()
          .db
          .collection("reservations")
          .where("contactId", isEqualTo: contactId)
          .get();

      if (resultReservations.docs.isNotEmpty) {
        statusCode = "200";
        final List<ReservationModel> reservations = resultReservations.docs
            .map((e) => ReservationModel.fromJson(e))
            .toList();
        return reservations;
      } else {
        statusCode = "200";
        final List<ReservationModel> reservations = [];
        return reservations;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// menghapus reservasi
  deleteReservation(String id) async {
    statusCode = "";
    try {
      await Repositories().db.collection("reservations").doc(id).delete();
      statusCode = "200";
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// menyetujui reservasi
  updateStatusReservation(
    String id,
    String status,
  ) async {
    statusCode = "";
    try {
      await Repositories()
          .db
          .collection("reservations")
          .doc(id)
          .update({"status": status});
      statusCode = "200";
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// mendapatkan informasi dan pengecekan status tersedia reservasi
  getReservationAvail(
    String dateStart,
    String dateEnd,
    String agency,
    String buildingName,
  ) async {
    statusCode = "";
    final List<ReservationModel> noBooking = [];

    try {
      QuerySnapshot resultReservation = await Repositories()
          .db
          .collection("reservations")
          .where("agency", isEqualTo: agency)
          .where("buildingName", isEqualTo: buildingName)
          .get();
      if (resultReservation.docs.isNotEmpty) {
        final List<ReservationModel> listReservation = resultReservation.docs
            .map((e) => ReservationModel.fromJson(e))
            .toList();

        final List<ReservationModel> reservationBookedByDate = listReservation
            .where(
              (element) =>
                  DateTime.parse(element.dateEnd!)
                          .isAfter(DateTime.parse(dateStart)) &&
                      DateTime.parse(element.dateStart!)
                          .isBefore(DateTime.parse(dateEnd)) &&
                      element.status == "Disetujui" ||
                  DateTime.parse(element.dateStart!)
                      .isAtSameMomentAs(DateTime.parse(dateEnd)) ||
                  DateTime.parse(element.dateEnd!)
                      .isAtSameMomentAs(DateTime.parse(dateStart)),
            )
            .toList();
        if (reservationBookedByDate.isNotEmpty) {
          statusCode = "201";
          return reservationBookedByDate;

        } else {
          statusCode = "200";
          return noBooking;
        }
      } else {
        statusCode = "200";
        return noBooking;
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  /// mendapatkan informasi reservasi bagi admin (berdasarkan instansi)
  getReservationForAdmin(String agency) async {
    error = "";
    statusCode = "";

    try {
      QuerySnapshot resultReservations = await Repositories()
          .db
          .collection("reservations")
          .where("agency", isEqualTo: agency)
          .get();

      if (resultReservations.docs.isNotEmpty) {
        statusCode = "200";
        final List<ReservationModel> reservations = resultReservations.docs
            .map((e) => ReservationModel.fromJson(e))
            .toList();
        final onReservation = reservations
            .where(
              (element) =>
                  element.status == "Menunggu" || element.status == "Disetujui",
            )
            .toList();
        return onReservation;
      } else {
        statusCode = "200";
        final List<ReservationModel> reservations = [];
        return reservations;
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
