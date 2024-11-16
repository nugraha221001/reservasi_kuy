import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/bloc/register/register_bloc.dart';
import '../../../data/model/user_model.dart';
import '../../widgets/general/button_positive.dart';
import '../../widgets/general/header_detail_page.dart';
import '../../widgets/general/pop_up.dart';
import '../../widgets/general/widget_custom_loading.dart';
import '../../widgets/general/widget_custom_text_form_field.dart';
import '../../widgets/general/widget_custom_title_text_form_field.dart';
import 'widget_profile_text_field.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late TextEditingController idController;
  late TextEditingController agencyController;
  late TextEditingController usernameController;
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController temporaryController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyEdit = GlobalKey<FormState>();
  late RegisterBloc registerBloc;

  /// fungsi mengedit user
  editUser() {
    return () {
      registerBloc = context.read<RegisterBloc>();
      registerBloc.add(EditUserAdmin(
        idController.text,
        agencyController.text,
        usernameController.text,
        passwordController.text,
        fullNameController.text,
        emailController.text,
        phoneController.text,
      ));
    };
  }

  /// fungsi mengedit username
  changeUsername() {
    registerBloc = context.read<RegisterBloc>();
    registerBloc.add(ChangeUsername(
      idController.text,
      usernameController.text,
    ));
  }

  /// popup ketika mengedit 1 field
  /// TODO ubah menjadi custom function widget dan errornya
  popUpEditUsername(
    String fieldName,
    TextEditingController controller,
    IconData prefixIcon,
  ) {
    temporaryController.text = controller.text;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is ChangeUsernameSuccess) {
              Navigator.of(context).pop();
            }
          },
          child: AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            title: Center(
              child: Text(
                "Edit $fieldName",
                style: GoogleFonts.openSans(),
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: 90,
              child: Form(
                key: formKeyEdit,
                child: Column(
                  children: [
                    CustomTextFormField(
                      fieldName: fieldName,
                      controller: temporaryController,
                      prefixIcon: prefixIcon,
                    ),

                    /// error when username is exist
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        if (state is ChangeUsernameFailed) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                state.error,
                                style: GoogleFonts.openSans(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          );
                        } else if (state is RegisterLoading) {
                          return const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Colors.blueAccent,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (formKeyEdit.currentState!.validate()) {
                        controller.text = temporaryController.text;
                        changeUsername();
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueAccent),
                      child: const Center(
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    idController = TextEditingController(text: widget.userModel.id);
    agencyController = TextEditingController(text: widget.userModel.agency);
    usernameController = TextEditingController(text: widget.userModel.username);
    fullNameController = TextEditingController(text: widget.userModel.fullName);
    emailController = TextEditingController(text: widget.userModel.email);
    phoneController = TextEditingController(text: widget.userModel.phone);
    passwordController = TextEditingController(text: widget.userModel.password);
    temporaryController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    idController.dispose();
    agencyController.dispose();
    usernameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    temporaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is EditSuccess) {
          PopUp().whenSuccessDoSomething(
            context,
            "Berhasil melakukan perubahan",
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
                const HeaderDetailPage(
                  pageName: "Edit User",
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {},
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Gap(10),
                              const CustomTitleTextFormField(
                                subtitle: "Username",
                              ),
                              CustomProfileTextFormField(
                                fieldName: "Username",
                                controller: usernameController,
                                prefixIcon: Icons.person,
                                isEdit: true,
                                function: () {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((_) {
                                    popUpEditUsername(
                                      "Username",
                                      usernameController,
                                      Icons.person,
                                    );
                                  });
                                },
                              ),
                              const CustomTitleTextFormField(
                                subtitle: "Instansi",
                              ),
                              CustomTextFormField(
                                fieldName: "Instansi",
                                controller: agencyController,
                                prefixIcon: Icons.corporate_fare,
                                role: widget.userModel.role,
                              ),
                              const CustomTitleTextFormField(
                                subtitle: "Nama",
                              ),
                              CustomTextFormField(
                                fieldName: "Nama Lengkap",
                                controller: fullNameController,
                                prefixIcon: Icons.person,
                              ),
                              const CustomTitleTextFormField(
                                subtitle: "E-Mail",
                              ),
                              CustomTextFormField(
                                fieldName: "E-Mail",
                                controller: emailController,
                                prefixIcon: Icons.email,
                              ),
                              const CustomTitleTextFormField(
                                subtitle: "Nomor Telepon",
                              ),
                              CustomTextFormField(
                                fieldName: "Nomor Telepon",
                                controller: phoneController,
                                prefixIcon: Icons.phone_android,
                              ),
                              const CustomTitleTextFormField(
                                subtitle: "Kata Sandi",
                              ),
                              CustomTextFormField(
                                fieldName: "Password",
                                controller: passwordController,
                                prefixIcon: Icons.lock,
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
                                        "Simpan perubahan user?",
                                        Icons.person,
                                        editUser(),
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
                  ),
                ),
              ],
            ),
            BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                if (state is RegisterLoading) {
                  return const CustomLoading();
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
