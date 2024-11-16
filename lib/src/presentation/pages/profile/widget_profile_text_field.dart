import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomProfileTextFormField extends StatefulWidget {
  const CustomProfileTextFormField({
    super.key,
    required this.fieldName,
    required this.controller,
    required this.prefixIcon,
    this.function,
    this.isEdit,
    this.canVisible,
  });

  final String fieldName;
  final TextEditingController controller;
  final IconData prefixIcon;
  final VoidCallback? function;
  final bool? isEdit;
  final bool? canVisible;

  @override
  State<CustomProfileTextFormField> createState() =>
      _CustomProfileTextFormFieldState();
}

class _CustomProfileTextFormFieldState
    extends State<CustomProfileTextFormField> {
  bool obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 6,
        bottom: 12,
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText(widget.fieldName, obscureText),
        readOnly: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: _keyboardType(widget.fieldName),
        inputFormatters: _textInputFormatter(widget.fieldName),
        validator: _customValidator(widget.fieldName),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          prefixIcon: Icon(widget.prefixIcon),
          suffixIcon: _suffixIcon(
            widget.fieldName,
            widget.function ?? () {},
            widget.isEdit ?? false,
            widget.canVisible ?? false,
          ),
          hintStyle: GoogleFonts.openSans(),
          hintText: widget.fieldName,
        ),
      ),
    );
  }

  TextInputType _keyboardType(String fieldName) {
    if (fieldName == "Nomor Telepon") {
      return TextInputType.phone;
    } else if (fieldName == "E-Mail") {
      return TextInputType.emailAddress;
    } else {
      return TextInputType.text;
    }
  }

  List<TextInputFormatter> _textInputFormatter(String fieldName) {
    if (fieldName == "Username") {
      return [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
      ];
    } else if (fieldName == "Password") {
      return [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
      ];
    } else if (fieldName == "Nomor Telepon") {
      return [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ];
    } else if (fieldName == "E-Mail") {
      return [
        FilteringTextInputFormatter.allow(
          RegExp(r'[a-zA-Z0-9@._-]'),
        ),
      ];
    } else if (fieldName == "Nama Lengkap") {
      return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))];
    } else {
      // Default input formatter
      return [];
    }
  }

  _customValidator(String fieldName) {
    if (fieldName == "Password") {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Password tidak boleh kosong!';
        }
        // Validasi minimal 1 huruf besar dan kombinasi huruf dan angka
        if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]+$').hasMatch(value)) {
          return 'Password setidaknya mengandung huruf besar dan angka!';
        }
        if (value.length < 6) {
          return 'Password harus lebih dari 6 karakter!';
        }
        return null;
      };
    } else if (fieldName == "E-Mail") {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Email tidak boleh kosong!';
        }
        // Validasi format email
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Masukkan email dengan benar!';
        }
      };
    } else if (fieldName == "Nomor Telepon") {
      return (value) {
        if (value == null || value.isEmpty) {
          return 'Nomor telepon tidak boleh kosong!';
        }
        // validator tidak boleh kurang dari 10 digit
        if (value.length < 10 || !value.startsWith('08')) {
          return 'Masukkan nomor telepon dengan benar!';
        }
      };
    } else {
      return (value) {
        if (value == null || value.isEmpty) {
          return '$fieldName tidak boleh kosong!';
        } else {
          return null;
        }
      };
    }
  }

  _suffixIcon(
    String fieldName,
    VoidCallback function,
    bool isEdit,
    bool canVisible,
  ) {
    if (fieldName == "Password" && isEdit == true) {
      return IconButton(
        icon: const Icon(
          Icons.edit,
        ),
        onPressed: function,
      );
    } else if (fieldName == "Password" && canVisible == true) {
      return IconButton(
        icon: Icon(
          obscureText ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: _togglePasswordVisibility,
      );
    } else if (fieldName == "Password") {
      return const SizedBox();
    } else if (fieldName == "Username" && isEdit == true) {
      return IconButton(
        icon: const Icon(
          Icons.edit,
        ),
        onPressed: function,
      );
    } else if (fieldName == "Username" || fieldName == "Instansi") {
      return null;
    } else if (isEdit == true) {
      return IconButton(
        icon: const Icon(
          Icons.edit,
        ),
        onPressed: function,
      );
    } else {
      return null;
    }
  }

  _obscureText(String fieldName, bool obscureText) {
    if (fieldName == "Password") {
      return obscureText;
    } else {
      return false;
    }
  }
}
