import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reservation_app/src/presentation/widgets/general/pop_up.dart';
import 'package:reservation_app/src/presentation/widgets/general/widget_custom_loading.dart';

import '../../../data/bloc/user/user_bloc.dart';
import '../../../data/model/user_model.dart';
import '../../widgets/general/button_positive.dart';
import '../../widgets/general/header_detail_page.dart';
import '../../widgets/general/widget_custom_title_text_form_field.dart';
import '../../widgets/general/widget_custom_text_form_field.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  late TextEditingController oldPasswordController;
  late TextEditingController new1PasswordController;
  late TextEditingController new2PasswordController;
  late UserBloc userBloc;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    oldPasswordController = TextEditingController();
    new1PasswordController = TextEditingController();
    new2PasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    new1PasswordController.dispose();
    new2PasswordController.dispose();
    super.dispose();
  }

  editPassword() {
    return () {
      userBloc = context.read<UserBloc>();
      userBloc.add(
        EditPassword(
          widget.userModel.id!,
          widget.userModel.username!,
          oldPasswordController.text,
          new1PasswordController.text,
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is EditPasswordSuccess) {
          PopUp().whenSuccessDoSomething(
            context,
            "Berhasil mengubah password",
            Icons.check_circle,
            true,
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                const HeaderDetailPage(pageName: "Ubah Kata Sandi"),
                RefreshIndicator(
                  onRefresh: () async {},
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(20),
                            const CustomTitleTextFormField(subtitle: "Kata Sandi Lama"),
                            CustomTextFormField(
                              fieldName: "Kata Sandi Lama",
                              controller: oldPasswordController,
                              prefixIcon: Icons.lock,
                            ),
                            const CustomTitleTextFormField(subtitle: "Kata Sandi Baru"),
                            CustomTextFormField(
                              fieldName: "Kata Sandi Baru",
                              controller: new1PasswordController,
                              prefixIcon: Icons.lock,
                            ),
                            const CustomTitleTextFormField(
                                subtitle: "Konfirmasi Kata Sandi Baru"),
                            CustomTextFormField(
                              fieldName: "Konfirmasi Kata Sandi Baru",
                              controller: new2PasswordController,
                              controller2: new1PasswordController,
                              prefixIcon: Icons.lock,
                            ),
                            const Gap(20),
                            BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                if (state is EditPasswordFailed) {
                                  return Center(
                                    child: Text(
                                      state.error,
                                      style: GoogleFonts.openSans(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                            const Gap(20),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ButtonPositive(
                                name: "Simpan Perubahan",
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    PopUp().whenDoSomething(
                                      context,
                                      "Yakin ingin mengganti kata sandi?",
                                      Icons.lock,
                                      editPassword(),
                                    );
                                  }
                                },
                              ),
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
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return const CustomLoading();
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
