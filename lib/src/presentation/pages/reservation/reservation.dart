import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reservation_app/src/presentation/widgets/general/pop_up.dart';

import '../../../data/bloc/reservation/reservation_bloc.dart';
import '../../../data/bloc/reservation_building/reservation_building_bloc.dart';
import '../../../data/model/building_model.dart';
import '../../utils/general/parsing.dart';
import '../../utils/routes/route_name.dart';
import '../../widgets/general/button_positive.dart';
import '../../widgets/general/header_pages.dart';
import '../../widgets/general/widget_custom_loading.dart';
import 'building_available_card_view.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  late TextEditingController dateStartController;
  late TextEditingController dateEndController;
  late DateTimeRange selectedTimeRange;
  late ReservationBuildingBloc reservationBuildingBloc;
  late ReservationBloc reservationBloc;
  late BuildingModel building;

  /// fungsi untuk mengambil rentang tanggal
  pickRangeDate(BuildContext context) async {
    final DateTimeRange? dateTimeRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      helpText: "Pilih tanggal",
      saveText: "Simpan",
    );
    if (dateTimeRange != null) {
      setState(() {
        selectedTimeRange = dateTimeRange;
        dateStartController =
            TextEditingController(text: selectedTimeRange.start.toString());
        dateEndController =
            TextEditingController(text: selectedTimeRange.end.toString());
      });
      getBuildingAvail();
    }
  }

  /// mendapatkan gedung yang tersedia
  getBuildingAvail() {
    reservationBuildingBloc = context.read<ReservationBuildingBloc>();
    reservationBuildingBloc.add(GetBuildingAvail());
  }

  /// pengecekan gedung yang tersedia
  getReservationAvail(String dateStart, String dateEnd, String buildingName) {
    reservationBloc = context.read<ReservationBloc>();
    reservationBloc.add(GetReservationCheck(dateStart, dateEnd, buildingName));
  }

  /// building initial
  buildingAvailInitial() {
    reservationBuildingBloc = context.read<ReservationBuildingBloc>();
    reservationBuildingBloc.add(InitialBuildingAvail());
  }

  @override
  void initState() {
    selectedTimeRange = DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now(),
    );
    buildingAvailInitial();
    dateStartController = TextEditingController();
    dateEndController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    dateStartController.dispose();
    dateEndController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationBloc, ReservationState>(
      listener: (context, state) {
        if (state is ReservationBooked) {
          if (state.booked.isNotEmpty) {
            // showToast(context, "Tidak tersedia pada tanggal ini");
            PopUp().whenSuccessDoSomething(
              context,
              "Dipakai oleh ${state.booked.first.contactName}\nMulai: ${ParsingString().convertDate(state.booked.first.dateStart!)}\nSelesai: ${ParsingString().convertDate(state.booked.first.dateEnd!)}",
              Icons.person,
            );
          }
        } else if (state is ReservationNoBooked) {
          PopUp().whenDoSomething(
            context,
            "Bisa melakukan reservasi. Reservasi sekarang?",
            Icons.corporate_fare,
                () {
              return context.pushNamed(
                Routes().confirmReservation,
                extra: building,
                queryParameters: {
                  "dateStart": dateStartController.text.toString(),
                  "dateEnd": dateEndController.text.toString(),
                },
              );
            },
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                const HeaderPage(
                  name: "Reservasi",
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      if (dateStartController.text.isNotEmpty &&
                          dateEndController.text.isNotEmpty) {
                        setState(() {
                          dateStartController.clear();
                          dateEndController.clear();
                        });
                      }
                      buildingAvailInitial();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 32,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.black,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: IntrinsicHeight(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pilih tanggal reservasi",
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Gap(10),
                                      selectedDateRange(),
                                      const Divider(
                                        height: 1,
                                        color: Colors.black,
                                        thickness: 1,
                                      ),
                                      const Gap(30),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: ButtonPositive(
                                          name: "Cari Gedung",
                                          function: buttonSearch(),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Gap(18),
                            BlocBuilder<ReservationBuildingBloc,
                                ReservationBuildingState>(
                              builder: (context, state) {
                                if (state is ResBuGetSuccess) {
                                  final buildings = state.buildings;
                                  buildings.sort((a, b) => a.name!.compareTo(b.name!));
                                  if (buildings.isNotEmpty) {
                                    return Column(
                                      children: [
                                        Text(
                                          "Gedung yang tersedia",
                                          style: GoogleFonts.openSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        ListView.builder(
                                          padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 30,
                                          ),
                                          itemCount: buildings.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: BuildingAvailableCardView(
                                                building: buildings[index],
                                                function: () {
                                                  building = buildings[index];
                                                  getReservationAvail(
                                                    dateStartController.text,
                                                    dateEndController.text,
                                                    buildings[index].name!,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Text(
                                          "Tidak ada gedung/ruang yang tersedia",
                                          style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  return const SizedBox();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Center(
              child: BlocBuilder<ReservationBuildingBloc,
                  ReservationBuildingState>(
                builder: (context, state) {
                  if (state is ResBuLoading) {
                    return const CustomLoading();
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  buttonSearch() {
    if (dateStartController.text.isEmpty || dateEndController.text.isEmpty) {
      return () {};
    } else {
      return () {
        getBuildingAvail();
      };
    }
  }

  selectedDateRange() {
    if (dateStartController.text.isNotEmpty &&
        dateEndController.text.isNotEmpty) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(
                    8,
                  ),
                  child: InkWell(
                    onTap: () {
                      pickRangeDate(context);
                    },
                    child: const Icon(
                      Icons.date_range,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${ParsingString().convertDate(
                          dateStartController.text,
                        )} - ${ParsingString().convertDate(
                          dateEndController.text,
                        )}",
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              dateStartController.clear();
                              dateEndController.clear();
                              buildingAvailInitial();
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(
                    8,
                  ),
                  child: InkWell(
                    onTap: () {
                      pickRangeDate(context);
                    },
                    child: const Icon(
                      Icons.date_range,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${(selectedTimeRange.duration.inDays.toInt() + 1)} Hari",
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  pickRangeDate(context);
                },
                child: const Icon(
                  Icons.date_range,
                  size: 30,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              "Pilih tanggal reservasi",
              style: GoogleFonts.openSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }
  }
}
