import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:reservation_app/src/data/model/user_model.dart';
import 'package:reservation_app/src/presentation/widgets/general/pop_up.dart';

import '../../../data/bloc/user/user_bloc.dart';
import '../../utils/constant/constant.dart';
import '../../utils/general/image_picker.dart';

class ProfilePictureFullScreen extends StatefulWidget {
  const ProfilePictureFullScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<ProfilePictureFullScreen> createState() =>
      _ProfilePictureFullScreenState();
}

class _ProfilePictureFullScreenState extends State<ProfilePictureFullScreen> {
  Uint8List? imagePicked;
  late TextEditingController imageController;
  late UserBloc userBloc;

  @override
  void didChangeDependencies() {
    imageController = TextEditingController(text: widget.user.image);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    imageController.dispose();
    super.dispose();
  }

  /// umum: pilih image dan update image
  selectImage() async {
    Uint8List img = await StoreData().pickImage(ImageSource.gallery);
    final urlImage = await StoreData().uploadImageToStorage(
        "profile_picture",
        "${widget.user.username}${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}",
        img);
    setState(() {
      imagePicked = img;
    });
    uploadImage(urlImage);
  }

  /// umum: upload image
  uploadImage(String urlImage) {
    userBloc = context.read<UserBloc>();
    userBloc.add(
      EditProfilePicture(
        widget.user.id!,
        urlImage,
      ),
    );
  }

  /// umum: delete image
  deleteImage() {
    return () {
      userBloc = context.read<UserBloc>();
      userBloc.add(
        EditProfilePicture(
          widget.user.id!,
          "",
        ),
      );
    };
  }

  imageLoader() {
    if (imagePicked != null) {
      return Image(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        image: MemoryImage(imagePicked!),
        fit: BoxFit.cover,
      );
    } else {
      if (imageController.text == "") {
        return Image.asset(
          assetsDefaultProfilePicture,
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        );
      } else {
        return CachedNetworkImage(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          imageUrl: imageController.text,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          errorWidget: (context, url, error) {
            return Image.asset(
              assetsDefaultProfilePicture,
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is EditSingleUserSuccess) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Column(
              children: [
                const Gap(30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          selectImage();
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          PopUp().whenDoSomething(
                            context,
                            "Hapus foto profil?",
                            Icons.delete,
                            deleteImage(),
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: Hero(
                tag: "profilePicture",
                child: imageLoader(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
