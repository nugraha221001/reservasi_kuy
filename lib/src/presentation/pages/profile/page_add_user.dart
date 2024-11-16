import 'package:flutter/material.dart';
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

class AddUserPage extends StatefulWidget {
  const AddUserPage({
    super.key,
    required this.userModel,
  });

  final UserModel userModel;

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  late TextEditingController agencyController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController fullNameController;
  late TextEditingController roleController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late RegisterBloc registerBloc;

  /// fungsi menambahkan user
  register(String role) {
    return () {
      registerBloc = context.read<RegisterBloc>();
      registerBloc.add(
        Register(
          agencyController.text,
          usernameController.text,
          passwordController.text,
          fullNameController.text,
          role,
        ),
      );
    };
  }

  @override
  void initState() {
    agencyController = TextEditingController(text: widget.userModel.agency);
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    fullNameController = TextEditingController();
    roleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    agencyController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          PopUp().whenSuccessDoSomething(
              context, "User berhasil ditambahkan", Icons.check_circle, true,);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                const HeaderDetailPage(
                  pageName: "Tambah User",
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
                          child: contentByRole(),
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

  contentByRole() {
    if (widget.userModel.role == "1") {
      agencyController = TextEditingController(
        text: widget.userModel.agency!,
      );
    }
    return adminContent();
  }

  Column adminContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(10),
        const CustomTitleTextFormField(subtitle: "Nama Lengkap"),
        CustomTextFormField(
          fieldName: "Nama Lengkap",
          controller: fullNameController,
          prefixIcon: Icons.contact_mail,
        ),
        const Gap(10),
        const CustomTitleTextFormField(subtitle: "Username"),
        CustomTextFormField(
          fieldName: "Username",
          controller: usernameController,
          prefixIcon: Icons.person,
        ),
        const Gap(10),
        const CustomTitleTextFormField(subtitle: "Password"),
        CustomTextFormField(
          fieldName: "Password",
          controller: passwordController,
          prefixIcon: Icons.lock,
        ),
        const Gap(10),
        const CustomTitleTextFormField(subtitle: "Instansi"),
        CustomTextFormField(
          fieldName: "Instansi",
          controller: agencyController,
          prefixIcon: Icons.corporate_fare,
          role: widget.userModel.role,
        ),
        const Gap(20),
        BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            if (state is RegisterFailed) {
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
            name: "Tambah User",
            function: () {
              if (formKey.currentState!.validate()) {
                if (widget.userModel.role == "0") {
                  PopUp().whenDoSomething(
                    context,
                    "Tambah user?",
                    Icons.person,
                    register("1"),
                  );
                } else {
                  PopUp().whenDoSomething(
                    context,
                    "Tambah user?",
                    Icons.person,
                    register("2"),
                  );
                }
              }
            },
          ),
        ),
        const Gap(30),
      ],
    );
  }
}
