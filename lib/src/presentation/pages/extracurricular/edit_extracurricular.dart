import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../data/bloc/extracurricular/extracurricular_bloc.dart';
import '../../../data/model/extracurricular_model.dart';
import '../../utils/constant/constant.dart';
import '../../utils/general/image_picker.dart';
import '../../widgets/general/header_detail_page.dart';
import '../../widgets/general/pop_up.dart';
import '../../widgets/general/widget_custom_title_text_form_field.dart';

class EditExtracurricularPage extends StatefulWidget {
  const EditExtracurricularPage({super.key, required this.excur});

  final ExtracurricularModel excur;

  @override
  State<EditExtracurricularPage> createState() =>
      _EditExtracurricularPageState();
}

class _EditExtracurricularPageState extends State<EditExtracurricularPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController excurNameController;
  late TextEditingController descController;
  late TextEditingController scheduleController;
  late TextEditingController imageController;
  late ExtracurricularBloc excurBloc;
  Uint8List? imagePicked;

  updateExcur(BuildContext context) {
    return () async {
      if (imagePicked != null) {
        final urlImage = await StoreData().uploadImageToStorage(
          "extracurricular",
          DateFormat('yyyyMMddHHmmss').format(DateTime.now()),
          imagePicked!,
        );

        if (!context.mounted) return;
        excurBloc = context.read<ExtracurricularBloc>();
        excurBloc.add(
          UpdateExtracurricular(
            widget.excur.id!,
            excurNameController.text,
            descController.text,
            scheduleController.text,
            urlImage,
            widget.excur.name!,
          ),
        );
      } else {
        excurBloc = context.read<ExtracurricularBloc>();
        excurBloc.add(
          UpdateExtracurricular(
            widget.excur.id!,
            excurNameController.text,
            descController.text,
            scheduleController.text,
            imageController.text,
            widget.excur.name!,
          ),
        );
      }
    };
  }

  selectImage() async {
    Uint8List img = await StoreData().pickImage(ImageSource.gallery);
    setState(() {
      imagePicked = img;
    });
  }

  imageLoader() {
    if (widget.excur.image! == "") {
      return const Image(
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        image: AssetImage(assetsDefaultBuildingImage),
      );
    } else {
      return CachedNetworkImage(
        height: 250,
        width: double.infinity,
        imageUrl: widget.excur.image!,
        placeholder: (context, url) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        errorWidget: (context, url, error) {
          return const Image(
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
            image: AssetImage(assetsDefaultBuildingImage),
          );
        },
      );
    }
  }

  @override
  void initState() {
    excurNameController = TextEditingController(text: widget.excur.name);
    descController = TextEditingController(text: widget.excur.description);
    scheduleController = TextEditingController(text: widget.excur.schedule);
    imageController = TextEditingController(text: widget.excur.image);
    super.initState();
  }

  @override
  void dispose() {
    excurNameController.dispose();
    descController.dispose();
    scheduleController.dispose();
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExtracurricularBloc, ExtracurricularState>(
      listener: (context, state) {
        if (state is ExtracurricularUpdateSuccess) {
          PopUp().whenSuccessDoSomething(
            context,
            "Perubahan berhasil",
            Icons.check_circle,
            true,
          );
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            const HeaderDetailPage(pageName: "Edit Ekstrakurikuler"),
            Expanded(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {},
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                                          return imageLoader();
                                        }
                                      },
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blueAccent
                                              .withOpacity(0.3),
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
                                                color: Colors.blueAccent
                                                    .withOpacity(0.3),
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      imagePicked = null;
                                                    });
                                                  },
                                                  customBorder:
                                                      const CircleBorder(),
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
                              const Gap(10),
                              const CustomTitleTextFormField(
                                subtitle: "Nama Ekstrakurikuler",
                              ),
                              TextFormField(
                                controller: excurNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama kegiatan tidak boleh kosong!';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Nama kegiatan ekstrakurikuler",
                                  prefixIcon: Icon(Icons.corporate_fare),
                                ),
                              ),
                              const Gap(10),
                              const CustomTitleTextFormField(
                                subtitle: "Deskripsi",
                              ),
                              TextFormField(
                                controller: descController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Deskripsi tidak boleh kosong!';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Deskripsi kegiatan",
                                  prefixIcon: Icon(Icons.description),
                                ),
                              ),
                              const Gap(10),
                              const CustomTitleTextFormField(
                                subtitle: "Jadwal Kegiatan",
                              ),
                              TextFormField(
                                controller: scheduleController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Jadwal kegiatan tidak boleh kosong!';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Jadwal kegiatan ekstrakurikuler",
                                  prefixIcon: Icon(Icons.badge_rounded),
                                ),
                              ),
                              const Gap(15),
                              BlocBuilder<ExtracurricularBloc,
                                  ExtracurricularState>(
                                builder: (context, state) {
                                  if (state is ExtracurricularUpdateFailed) {
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          PopUp().whenDoSomething(
                                            context,
                                            "Simpan perubahan?",
                                            Icons.question_mark,
                                            updateExcur(context),
                                          );
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Text(
                                          "Simpan",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  BlocBuilder<ExtracurricularBloc, ExtracurricularState>(
                    builder: (context, state) {
                      if (state is ExtracurricularLoading) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color(0x80FFFFFF),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
