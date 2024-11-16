import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:reservation_app/src/presentation/widgets/general/widget_custom_loading.dart';

import '../../../data/bloc/building/building_bloc.dart';
import '../../utils/constant/constant.dart';
import '../../utils/general/image_picker.dart';
import '../../utils/routes/route_name.dart';
import '../../widgets/general/button_positive.dart';
import '../../widgets/general/header_detail_page.dart';
import '../../widgets/general/pop_up.dart';
import '../../widgets/general/widget_custom_text_form_field.dart';
import '../../widgets/general/widget_custom_title_text_form_field.dart';
import 'widget_edit_building_card_view.dart';

class AddBuildingPage extends StatefulWidget {
  const AddBuildingPage({super.key});

  @override
  State<AddBuildingPage> createState() => _AddBuildingPageState();
}

class _AddBuildingPageState extends State<AddBuildingPage>
    with TickerProviderStateMixin {
  late TextEditingController buildingNameController;
  late TextEditingController descController;
  late TextEditingController facilityController;
  late TextEditingController capacityController;
  late TextEditingController ruleController;
  late TextEditingController imageController;
  late TextEditingController statusController;
  late TabController _tabController;
  late BuildingBloc _buildingBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Uint8List? imagePicked;

  /// menambahkan gedung
  addBuilding(BuildContext context) {
    return () async {
      if (imagePicked != null) {
        final urlImage = await StoreData().uploadImageToStorage(
          "building",
          DateFormat('yyyyMMddHHmmss').format(DateTime.now()),
          imagePicked!,
        );

        if (!context.mounted) return;
        _buildingBloc = context.read<BuildingBloc>();
        _buildingBloc.add(
          AddBuilding(
            buildingNameController.text,
            descController.text,
            facilityController.text,
            int.parse(capacityController.text),
            ruleController.text,
            urlImage,
          ),
        );
      } else {
        _buildingBloc = context.read<BuildingBloc>();
        _buildingBloc.add(
          AddBuilding(
            buildingNameController.text,
            descController.text,
            facilityController.text,
            int.parse(capacityController.text),
            ruleController.text,
            imageController.text,
          ),
        );
      }
    };
  }

  /// mendapatkan info gedung
  _getBuilding() {
    _buildingBloc = context.read<BuildingBloc>();
    _buildingBloc.add(GetBuildingByAgency());
  }

  /// menghapus gedung
  deleteBuilding(String id) {
    return () {
      _buildingBloc = context.read<BuildingBloc>();
      _buildingBloc.add(DeleteBuilding(id));
    };
  }

  /// pilih gambar dari perangkat
  selectImage() async {
    Uint8List img = await StoreData().pickImage(ImageSource.gallery);
    setState(() {
      imagePicked = img;
    });
  }

  @override
  void initState() {
    buildingNameController = TextEditingController();
    descController = TextEditingController();
    facilityController = TextEditingController();
    capacityController = TextEditingController();
    ruleController = TextEditingController();
    imageController = TextEditingController();
    statusController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    buildingNameController.dispose();
    descController.dispose();
    facilityController.dispose();
    capacityController.dispose();
    ruleController.dispose();
    imageController.dispose();
    statusController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BuildingBloc, BuildingState>(
      listener: (context, state) {
        if (state is BuildingAddSuccess) {
          PopUp().whenSuccessDoSomething(
            context,
            "Berhasil menambah gedung",
            Icons.check_circle,
            true,
          );
        } else if (state is BuildingDeleteSuccess) {
          PopUp().whenSuccessDoSomething(
            context,
            "Berhasil menghapus gedung",
            Icons.check_circle,
            true,
          );
          context.pop();
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  const HeaderDetailPage(
                    pageName: "Tambah Gedung",
                  ),
                  TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                    ),
                    tabs: const [
                      Tab(text: 'Tambah'),
                      Tab(text: 'Edit/Hapus'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        ///first tab bar
                        addBuildingContent(),

                        ///second tab bar
                        manageBuildingContent(),
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
            ],
          ),
        ),
      ),
    );
  }

  RefreshIndicator addBuildingContent() {
    return RefreshIndicator(
      onRefresh: () async {},
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                Center(
                  child: Stack(
                    children: [
                      Builder(
                        builder: (context) {
                          if (imagePicked != null) {
                            return Image(
                              height: 250,
                              width: double.infinity,
                              image: MemoryImage(imagePicked!),
                              fit: BoxFit.cover,
                            );
                          } else {
                            if (imageController.text == "") {
                              return const Image(
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                image: AssetImage(assetsDefaultBuildingImage),
                              );
                            } else {
                              return const Image(
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                image: AssetImage(assetsDefaultBuildingImage),
                              );
                            }
                          }
                        },
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueAccent.withOpacity(0.3),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                selectImage();
                              },
                              customBorder: const CircleBorder(),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  imagePicked != null
                                      ? Icons.edit
                                      : Icons.add_photo_alternate,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      imagePicked != null
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueAccent.withOpacity(0.3),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        imagePicked = null;
                                      });
                                    },
                                    customBorder: const CircleBorder(),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4),
                                      child: Icon(
                                        Icons.delete,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                const Gap(20),
                const CustomTitleTextFormField(subtitle: "Nama Gedung"),
                CustomTextFormField(
                  fieldName: "Nama Gedung",
                  controller: buildingNameController,
                  prefixIcon: Icons.corporate_fare,
                ),
                const CustomTitleTextFormField(subtitle: "Deskripsi"),
                CustomTextFormField(
                  fieldName: "Deskripsi Gedung",
                  controller: descController,
                  prefixIcon: Icons.description,
                ),
                const CustomTitleTextFormField(subtitle: "Fasilitas"),
                CustomTextFormField(
                  fieldName: "Fasilitas Gedung",
                  controller: facilityController,
                  prefixIcon: Icons.badge,
                ),
                const CustomTitleTextFormField(subtitle: "Kapasitas"),
                CustomTextFormField(
                  fieldName: "Kapasitas Gedung",
                  controller: capacityController,
                  prefixIcon: Icons.groups,
                ),
                const CustomTitleTextFormField(subtitle: "Peraturan"),
                CustomTextFormField(
                  fieldName: "Peraturan Gedung",
                  controller: ruleController,
                  prefixIcon: Icons.rule,
                ),
                const Gap(15),
                BlocBuilder<BuildingBloc, BuildingState>(
                  builder: (context, state) {
                    if (state is BuildingAddFailed) {
                      return Center(
                        child: Text(
                          state.error,
                          style: GoogleFonts.openSans(
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const Gap(15),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ButtonPositive(
                    name: "Tambah",
                    function: () {
                      if (_formKey.currentState!.validate()) {
                        PopUp().whenDoSomething(
                          context,
                          "Tambah gedung?",
                          Icons.corporate_fare,
                          addBuilding(context),
                        );
                      }
                    },
                  ),
                ),
                const Gap(30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  RefreshIndicator manageBuildingContent() {
    return RefreshIndicator(
      onRefresh: () async {
        _getBuilding();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<BuildingBloc, BuildingState>(
                builder: (context, state) {
                  if (state is BuildingGetSuccess) {
                    final buildings = state.buildings;
                    if (buildings.isNotEmpty) {
                      return Column(
                        children: [
                          Text(
                            "Daftar Gedung",
                            style: GoogleFonts.openSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Gap(10),
                          ListView.builder(
                            itemCount: buildings.length,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                              bottom: 80,
                            ),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: EditBuildingCardView(
                                  building: buildings[index],
                                  functionEdit: () {
                                    context.pushNamed(
                                      Routes().editBuilding,
                                      extra: buildings[index],
                                    );
                                  },
                                  functionDelete: () {
                                    PopUp().whenDoSomething(
                                      context,
                                      "Ingin menghapus ${buildings[index].name}?",
                                      Icons.delete_forever,
                                      deleteBuilding(buildings[index].id!),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        decoration:
                            const BoxDecoration(color: Color(0x80FFFFFF)),
                        child: Center(
                          child: Text(
                            "Tidak ada data gedung",
                            style: GoogleFonts.openSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
