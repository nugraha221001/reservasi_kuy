import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/bloc/history/history_bloc.dart';
import '../../../data/model/history_model.dart';
import '../../utils/general/parsing.dart';
import '../../widgets/general/header_pages.dart';
import '../../widgets/general/widget_custom_loading.dart';
import 'widget_history_card_view.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late HistoryBloc _historyBloc;
  late String userRole;
  String titleFilter = "Semua Laporan";
  DateTime? selectedDate;

  /// user: mendapatkan informasi riwayat
  _getHistory() {
    _historyBloc = context.read<HistoryBloc>();
    _historyBloc.add(GetHistoryUser());
  }

  /// admin: mendapatkan informasi laporan
  _getReport() {
    _historyBloc = context.read<HistoryBloc>();
    _historyBloc.add(GetReportAdmin());
  }

  /// umum: mendapatkan informasi laporan riwayat reservasi
  getHistoryReport() {
    if (userRole == "1") {
      return _getReport();
    } else if (userRole == "2") {
      return _getHistory();
    } else {
      return () {};
    }
  }

  /// umum: mendapatkan informasi role
  getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString("role")!;
    setState(() {
      userRole = userRole;
    });
  }

  @override
  void didChangeDependencies() {
    userRole = "";
    getRole();
    selectedDate = DateTime.now();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    getHistoryReport();
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                headerPage(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      getHistoryReport();
                    },
                    child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              BlocBuilder<HistoryBloc, HistoryState>(
                                builder: (context, state) {
                                  if (state is HistoryGetSuccess) {
                                    final histories = state.histories;
                                    if (histories.isNotEmpty) {
                                      return Column(children: [
                                        buttonFilter(histories),
                                        _historiesFiltered(histories).isNotEmpty
                                            ? groupedListView(histories)
                                            : isEmptyText(),
                                      ]);
                                    } else {
                                      return isEmptyText();
                                    }
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ],
            ),
            Center(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  if (state is HistoryLoading) {
                    return const CustomLoading();
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> monthPicker(BuildContext contexto) async {
    return await showMonthPicker(
      context: contexto,
      firstDate: DateTime(DateTime.now().year - 2, 5),
      lastDate: DateTime(DateTime.now().year + 2, 9),
      initialDate: selectedDate ?? DateTime.now(),
      confirmWidget: Text(
        'Pilih',
        style: GoogleFonts.openSans(
          fontWeight: FontWeight.w700,
          color: Colors.blueAccent,
        ),
      ),
      cancelWidget: Text(
        'Batal',
        style: GoogleFonts.openSans(
          fontWeight: FontWeight.w700,
          color: Colors.redAccent,
        ),
      ),
      monthPickerDialogSettings: MonthPickerDialogSettings(
        headerSettings: PickerHeaderSettings(
          headerBackgroundColor: Colors.blueAccent,
          headerCurrentPageTextStyle: GoogleFonts.openSans(
            fontSize: 14,
            color: Colors.white,
          ),
          headerSelectedIntervalTextStyle: GoogleFonts.openSans(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ).then((DateTime? date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
          titleFilter =
              "Bulan ${ParsingString().convertDateOnlyMonth(date.toString())}";
        });
      }
    });
  }

  buttonFilter(List<HistoryModel> histories) {
    final List<String> menuOptions = [
      'Semua Laporan',
      'Bulan Ini',
      'Pilih Bulan',
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            titleFilter,
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.filter_alt),
          onSelected: (String value) {
            if (value == "Pilih Bulan") {
              monthPicker(context);
            } else {
              setState(() {
                titleFilter = value;
              });
            }
          },
          itemBuilder: (BuildContext context) {
            return menuOptions.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(
                  choice,
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  List<HistoryModel> _historiesFiltered(List<HistoryModel> histories) {
    if (titleFilter == "Semua Laporan") {
      return histories;
    } else if (titleFilter == "Bulan Ini") {
      return histories
          .where(
            (element) =>
                ParsingString().convertDateOnlyMonth(element.dateStart!) ==
                ParsingString().convertDateOnlyMonth(DateTime.now().toString()),
          )
          .toList();
    } else if (titleFilter ==
        "Bulan ${ParsingString().convertDateOnlyMonth(selectedDate.toString())}") {
      return histories
          .where(
            (element) =>
                ParsingString().convertDateOnlyMonth(element.dateStart!) ==
                ParsingString().convertDateOnlyMonth(selectedDate.toString()),
          )
          .toList();
    } else {
      return histories;
    }
  }

  groupedListView(List<HistoryModel> histories) {
    return GroupedListView<HistoryModel, String>(
      padding: EdgeInsets.zero,
      elements: _historiesFiltered(histories),
      shrinkWrap: true,
      itemComparator: (a, b) => a.dateFinished!.compareTo(b.dateFinished!),
      groupBy: (element) => element.dateFinished == ""
          ? "A"
          : DateFormat('yyyy MM').format(DateTime.parse(element.dateFinished!)),
      order: GroupedListOrder.DESC,
      groupSeparatorBuilder: (String value) {
        return _groupSeparatorBuilder(value);
      },
      itemBuilder: (context, element) {
        return HistoryCardView(
          history: element,
          function: () {},
          role: userRole,
        );
      },
    );
  }

  Padding _groupSeparatorBuilder(String value) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
        top: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ParsingString().convertDateSwitchPosition(value),
            style: GoogleFonts.openSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  isEmptyText() {
    if (userRole == "1") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            "Tidak ada laporan reservasi",
            style: GoogleFonts.openSans(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (userRole == "2") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            "Tidak ada riwayat reservasi",
            style: GoogleFonts.openSans(
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  headerPage() {
    if (userRole == "1") {
      return const HeaderPage(
        name: "Laporan",
      );
    } else if (userRole == "2") {
      return const HeaderPage(
        name: "Riwayat Reservasi",
      );
    } else {
      return const SizedBox();
    }
  }
}
