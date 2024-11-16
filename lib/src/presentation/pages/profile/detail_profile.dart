import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../data/model/user_model.dart';
import '../../utils/constant/constant.dart';
import '../../widgets/general/header_detail_page.dart';
import '../../widgets/general/widget_custom_title_text_form_field.dart';
import 'widget_profile_text_field.dart';

class DetailProfilePage extends StatefulWidget {
  const DetailProfilePage({super.key, required this.userModel});

  final UserModel userModel;

  @override
  State<DetailProfilePage> createState() => _DetailProfilePageState();
}

class _DetailProfilePageState extends State<DetailProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController agencyController;
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  imageLoader() {
    if (widget.userModel.image == "") {
      return ClipOval(
        child: Image.asset(
          assetsDefaultProfilePicture,
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return ClipOval(
        child: CachedNetworkImage(
          height: 150,
          width: 150,
          imageUrl: widget.userModel.image!,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          errorWidget: (context, url, error) {
            return Image.asset(
              assetsDefaultProfilePicture,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
            );
          },
        ),
      );
    }
  }

  @override
  void initState() {
    usernameController = TextEditingController(text: widget.userModel.username);
    agencyController = TextEditingController(text: widget.userModel.agency);
    fullNameController = TextEditingController(text: widget.userModel.fullName);
    phoneController = TextEditingController(text: widget.userModel.phone);
    emailController = TextEditingController(text: widget.userModel.email);
    passwordController = TextEditingController(text: widget.userModel.password);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        HeaderDetailPage(pageName: widget.userModel.fullName!),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {},
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const Gap(30),
                  imageLoader(),
                  const Gap(20),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomTitleTextFormField(subtitle: "Username"),
                        CustomProfileTextFormField(
                          fieldName: "Username",
                          controller: usernameController,
                          prefixIcon: Icons.person,
                        ),
                        const CustomTitleTextFormField(subtitle: "Instansi"),
                        CustomProfileTextFormField(
                          fieldName: "Instansi",
                          controller: agencyController,
                          prefixIcon: Icons.corporate_fare,
                        ),
                        const CustomTitleTextFormField(
                            subtitle: "Nama Lengkap"),
                        CustomProfileTextFormField(
                          fieldName: "Nama Lengkap",
                          controller: fullNameController,
                          prefixIcon: Icons.contact_mail,
                        ),
                        const CustomTitleTextFormField(subtitle: "E-Mail"),
                        CustomProfileTextFormField(
                          fieldName: "E-Mail",
                          controller: emailController,
                          prefixIcon: Icons.email,
                        ),
                        const CustomTitleTextFormField(
                            subtitle: "Nomor Telepon"),
                        CustomProfileTextFormField(
                          fieldName: "Nomor Telepon",
                          controller: phoneController,
                          prefixIcon: Icons.phone_android,
                        ),
                        const CustomTitleTextFormField(subtitle: "Password"),
                        CustomProfileTextFormField(
                          fieldName: "Password",
                          controller: passwordController,
                          prefixIcon: Icons.lock,
                          canVisible: true,
                        ),
                        const Gap(30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
