import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/bloc/building/building_bloc.dart';
import '../../../data/bloc/extracurricular/extracurricular_bloc.dart';
import '../../utils/routes/route_name.dart';
import '../../widgets/general/header_pages.dart';
import '../../widgets/general/pop_up.dart';
import '../../widgets/general/widget_custom_loading.dart';
import '../extracurricular/widget_extracurricular_card_view.dart';
import 'widget_building_card_view.dart';
import '../../widgets/general/custom_fab.dart';

class BuildingPage extends StatefulWidget {
  const BuildingPage({super.key});

  @override
  State<BuildingPage> createState() => _BuildingPageState();
}

class _BuildingPageState extends State<BuildingPage>
    with TickerProviderStateMixin {
  late BuildingBloc buildingBloc;
  late ExtracurricularBloc excurBloc;
  late String roleUser;
  late TabController tabController;
  int selectedIndex = 0;

  /// mendapatkan informasi gedung
  getBuilding() {
    buildingBloc = context.read<BuildingBloc>();
    buildingBloc.add(GetBuildingByAgency());
  }

  /// mendapatkan ekstrakurikuler
  getExtracurricular() {
    excurBloc = context.read<ExtracurricularBloc>();
    excurBloc.add(GetExtracurricular());
  }

  /// mendapatkan role pengguna
  getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    roleUser = prefs.getString("role")!;
    setState(() {
      roleUser = roleUser;
    });
  }

  /// menghapus ekstrakurikuler
  deleteExcur(String id) {
    return () {
      excurBloc = context.read<ExtracurricularBloc>();
      excurBloc.add(DeleteExtracurricular(id));
    };
  }

  /// menghapus gedung
  deleteBuilding(String id) {
    return () {
      buildingBloc = context.read<BuildingBloc>();
      buildingBloc.add(DeleteBuilding(id));
    };
  }

  @override
  void didChangeDependencies() {
    roleUser = "";
    getRole();
    getBuilding();
    getExtracurricular();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: customFAB(),
        body: Stack(
          children: [
            Column(
              children: [
                const HeaderPage(
                  name: "Gedung & Ekstrakurikuler",
                ),
                const Gap(10),
                TabBar(
                  controller: tabController,
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  labelStyle: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelColor: Colors.black,
                  labelColor: Colors.white,
                  indicatorColor: Colors.transparent,
                  dividerColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  tabs: [
                    Tab(
                      child: Container(
                        width: double.maxFinite,
                        height: 40,
                        decoration: selectedIndex == 0
                            ? BoxDecoration(
                                color: Colors.blueAccent.shade400,
                                borderRadius: BorderRadius.circular(10),
                              )
                            : BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(10),
                              ),
                        child: const Center(
                          child: Text("Gedung"),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: double.maxFinite,
                        height: 40,
                        decoration: selectedIndex == 1
                            ? BoxDecoration(
                                color: Colors.blueAccent.shade400,
                                borderRadius: BorderRadius.circular(10),
                              )
                            : BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(10),
                              ),
                        child: const Center(
                          child: Text("Jadwal Ekskul"),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: [
                      /// first tab bar view
                      buildingContent(),

                      /// second tab bar view
                      extracurricularContent(),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: BlocBuilder<BuildingBloc, BuildingState>(
                builder: (context, state) {
                  if (state is BuildingLoading) {
                    return const CustomLoading();
                  }
                  return const SizedBox();
                },
              ),
            ),
            Center(
              child: BlocBuilder<ExtracurricularBloc, ExtracurricularState>(
                builder: (context, state) {
                  if (state is ExtracurricularLoading) {
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

  BlocListener buildingContent() {
    return BlocListener<BuildingBloc, BuildingState>(
      listener: (context, state) {
        if (state is BuildingDeleteSuccess) {
          PopUp().whenSuccessDoSomething(
            context,
            "Berhasil menghapus gedung",
            Icons.check_circle,
          );
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          getBuilding();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: BlocBuilder<BuildingBloc, BuildingState>(
            builder: (context, state) {
              if (state is BuildingGetSuccess) {
                final buildings = state.buildings;
                buildings.sort((a, b) => a.name!.compareTo(b.name!));
                if (buildings.isNotEmpty) {
                  return Column(
                    children: [
                      const Gap(10),
                      Text(
                        "Daftar Gedung",
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ListView.builder(
                        padding: const EdgeInsets.only(
                          bottom: 80,
                          top: 10,
                        ),
                        itemCount: buildings.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: BuildingCardView(
                              building: buildings[index],
                              editFunction: () {
                                context.pushNamed(
                                  Routes().editBuilding,
                                  extra: buildings[index],
                                );
                              },
                              deleteFunction: () {
                                PopUp().whenDoSomething(
                                    context,
                                    "Hapus ${buildings[index].name}?",
                                    Icons.delete_forever,
                                    deleteBuilding(
                                      buildings[index].id!,
                                    ));
                              },
                              detailFunction: () {
                                context.pushNamed(
                                  Routes().detailBuilding,
                                  extra: buildings[index],
                                );
                              },
                              role: roleUser,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      const Gap(30),
                      Center(
                        child: Text(
                          "Tidak ada gedung",
                          style: GoogleFonts.openSans(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  BlocListener extracurricularContent() {
    return BlocListener<ExtracurricularBloc, ExtracurricularState>(
      listener: (context, state) {
        if (state is ExtracurricularDeleteSuccess) {
          PopUp().whenSuccessDoSomething(
            context,
            "Berhasil menghapus ekskul",
            Icons.check_circle,
          );
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          getExtracurricular();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: BlocBuilder<ExtracurricularBloc, ExtracurricularState>(
            builder: (context, state) {
              if (state is ExtracurricularGetSuccess) {
                final excur = state.extracurriculars;
                excur.sort((a, b) => a.name!.compareTo(b.name!));
                if (excur.isNotEmpty) {
                  return Column(
                    children: [
                      const Gap(10),
                      Text(
                        "Daftar Ekstrakurikuler",
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      ListView.builder(
                        padding: const EdgeInsets.only(
                          bottom: 80,
                          top: 10,
                        ),
                        itemCount: excur.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ExtracurricularCardView(
                              excur: excur[index],
                              editFunction: () {
                                context.pushNamed(
                                  Routes().editExtracurricular,
                                  extra: excur[index],
                                );
                              },
                              deleteFunction: () {
                                PopUp().whenDoSomething(
                                  context,
                                  "Hapus ${excur[index].name!}?",
                                  Icons.delete_forever,
                                  deleteExcur(excur[index].id!),
                                );
                              },
                              detailFunction: () {
                                context.pushNamed(
                                  Routes().detailExtracurricular,
                                  extra: excur[index],
                                );
                              },
                              role: roleUser,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      const Gap(30),
                      Center(
                        child: Text(
                          "Tidak ada ekstrakurikuler",
                          style: GoogleFonts.openSans(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }

  customFAB() {
    if (roleUser == "1") {
      if (selectedIndex == 0) {
        return CustomFAB(
          iconData: Icons.add_home_work,
          function: () {
            context.pushNamed(
              Routes().createBuilding,
            );
          },
        );
      } else {
        return CustomFAB(
          iconData: Icons.add_home_work,
          function: () {
            context.pushNamed(
              Routes().createExtracurricular,
            );
          },
        );
      }
    } else {
      return const SizedBox();
    }
  }
}
