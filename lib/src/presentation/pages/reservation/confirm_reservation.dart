import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../data/bloc/reservation/reservation_bloc.dart';
import '../../../data/bloc/reservation_building/reservation_building_bloc.dart';
import '../../../data/bloc/user/user_bloc.dart';
import '../../../data/model/building_model.dart';
import '../../../data/model/user_model.dart';
import '../../utils/constant/constant.dart';
import '../../utils/general/parsing.dart';
import '../../widgets/general/button_positive.dart';
import '../../widgets/general/header_detail_page.dart';
import '../../widgets/general/pop_up.dart';
import '../../widgets/general/widget_custom_loading.dart';
import '../../widgets/general/widget_custom_text_form_field.dart';
import '../../widgets/general/widget_title_subtitle.dart';

class ConfirmReservationPage extends StatefulWidget {
  const ConfirmReservationPage({
    super.key,
    required this.building,
    required this.dateStart,
    required this.dateEnd,
  });

  final BuildingModel building;
  final String dateStart;
  final String dateEnd;

  @override
  State<ConfirmReservationPage> createState() => _ConfirmReservationPageState();
}

class _ConfirmReservationPageState extends State<ConfirmReservationPage> {
  late TextEditingController informationController;
  late ReservationBloc _reservationBloc;
  late UserBloc _userBloc;
  late UserModel user;

  /// mendapatkan info user
  getUser() {
    _userBloc = context.read<UserBloc>();
    _userBloc.add(GetUserLoggedIn());
  }

  /// membuat reservasi
  createReservation() {
    return () {
      _reservationBloc = context.read<ReservationBloc>();
      _reservationBloc.add(
        CreateReservation(
          widget.building.name!,
          user.username!,
          user.fullName!,
          user.email!,
          user.phone!,
          widget.dateStart,
          widget.dateEnd,
          informationController.text,
          user.agency!,
          widget.building.image!,
        ),
      );
    };
  }

  imageLoader() {
    if (widget.building.image! == "") {
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
        imageUrl: widget.building.image!,
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
    getUser();
    informationController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    informationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserGetSuccess) {
              user = state.user;
            }
          },
        ),
        BlocListener<ReservationBloc, ReservationState>(
          listener: (context, state) {
            if (state is ReservationCreateSuccess) {
              PopUp().whenSuccessDoSomething(
                context,
                "Mohon untuk menunggu konfirmasi dari admin",
                Icons.check_circle,
                true,
              );
              BlocProvider.of<ReservationBuildingBloc>(context).add(
                InitialBuildingAvail(),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                const HeaderDetailPage(pageName: "Konfirmasi Reservasi"),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {},
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(15),
                          imageLoader(),
                          const Gap(15),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleSubtitleDetailPage(
                                  title: widget.building.name!,
                                  subtitle: widget.building.description!,
                                  isTitle: true,
                                ),
                                TitleSubtitleDetailPage(
                                  title: "Fasilitas",
                                  subtitle: widget.building.facility!,
                                ),
                                TitleSubtitleDetailPage(
                                  title: "Kapasitas",
                                  subtitle:
                                      "${widget.building.capacity!.toString()} Orang",
                                ),
                                TitleSubtitleDetailPage(
                                  title: "Peraturan",
                                  subtitle: widget.building.rule!,
                                ),
                                TitleSubtitleDetailPage(
                                  title: "Status Gedung/Ruangan",
                                  subtitle: widget.building.status!,
                                ),
                                TitleSubtitleDetailPage(
                                  title: "Tanggal Pakai",
                                  subtitle:
                                      "${ParsingString().convertDate(widget.dateStart)} - ${ParsingString().convertDate(widget.dateEnd)}",
                                ),
                                CustomTextFormField(
                                  fieldName: "Keterangan",
                                  controller: informationController,
                                  prefixIcon: Icons.description,
                                ),
                                const Gap(30),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: ButtonPositive(
                                    name: "Reservasi Sekarang",
                                    function: () {
                                      PopUp().whenDoSomething(
                                        context,
                                        "Ingin melakukan reservasi?",
                                        Icons.corporate_fare,
                                        createReservation(),
                                      );
                                    },
                                  ),
                                ),
                                const Gap(40),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Center(
              child: BlocBuilder<ReservationBloc, ReservationState>(
                builder: (context, state) {
                  if (state is ReservationLoading) {
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
}

