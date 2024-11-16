import 'package:intl/intl.dart';

class ParsingString {
  String convertDate(String input) {
    final parsedEnglish =
    DateFormat('dd MMMM yyyy').format(DateTime.parse(input));
    return parsedEnglish.replaceAllMapped(
      RegExp(
          r'\b(January|February|March|April|May|June|July|August|September|October|November|December)\b'),
          (Match match) {
        switch (match.group(0)) {
          case 'January':
            return 'Januari';
          case 'February':
            return 'Februari';
          case 'March':
            return 'Maret';
          case 'April':
            return 'April';
          case 'May':
            return 'Mei';
          case 'June':
            return 'Juni';
          case 'July':
            return 'Juli';
          case 'August':
            return 'Agustus';
          case 'September':
            return 'September';
          case 'October':
            return 'Oktober';
          case 'November':
            return 'November';
          case 'December':
            return 'Desember';
          default:
            return match.group(0)!;
        }
      },
    );
  }

  String convertDateWithHour(String input) {
    final parsedEnglish =
    DateFormat('dd MMMM yyyy  kk:mm').format(DateTime.parse(input));
    return parsedEnglish.replaceAllMapped(
      RegExp(
          r'\b(January|February|March|April|May|June|July|August|September|October|November|December)\b'),
          (Match match) {
        switch (match.group(0)) {
          case 'January':
            return 'Januari';
          case 'February':
            return 'Februari';
          case 'March':
            return 'Maret';
          case 'April':
            return 'April';
          case 'May':
            return 'Mei';
          case 'June':
            return 'Juni';
          case 'July':
            return 'Juli';
          case 'August':
            return 'Agustus';
          case 'September':
            return 'September';
          case 'October':
            return 'Oktober';
          case 'November':
            return 'November';
          case 'December':
            return 'Desember';
          default:
            return match.group(0)!;
        }
      },
    );
  }

  String convertDateOnlyMonth(String input) {
    final parsedEnglish = DateFormat('MMMM yyyy').format(DateTime.parse(input));
    return parsedEnglish.replaceAllMapped(
      RegExp(
          r'\b(January|February|March|April|May|June|July|August|September|October|November|December)\b'),
          (Match match) {
        switch (match.group(0)) {
          case 'January':
            return 'Januari';
          case 'February':
            return 'Februari';
          case 'March':
            return 'Maret';
          case 'April':
            return 'April';
          case 'May':
            return 'Mei';
          case 'June':
            return 'Juni';
          case 'July':
            return 'Juli';
          case 'August':
            return 'Agustus';
          case 'September':
            return 'September';
          case 'October':
            return 'Oktober';
          case 'November':
            return 'November';
          case 'December':
            return 'Desember';
          default:
            return match.group(0)!;
        }
      },
    );
  }

  String convertDateSwitchPosition(String input) {
    // Regex untuk menangkap format "YYYY MM"
    final regex = RegExp(r'(\d{4})\s(\d{2})');
    final match = regex.firstMatch(input);

    if (match != null) {
      // Ambil tahun dan bulan dari regex
      final String year = match.group(1)!;
      final String monthNumber = match.group(2)!;

      // Mapping bulan dalam Bahasa Indonesia
      final Map<String, String> monthNames = {
        '01': 'Januari',
        '02': 'Februari',
        '03': 'Maret',
        '04': 'April',
        '05': 'Mei',
        '06': 'Juni',
        '07': 'Juli',
        '08': 'Agustus',
        '09': 'September',
        '10': 'Oktober',
        '11': 'November',
        '12': 'Desember',
      };

      // Dapatkan nama bulan berdasarkan angka bulan
      final String monthName = monthNames[monthNumber] ?? 'Bulan Tidak Diketahui';

      // Return hasil dalam format "Bulan Tahun"
      return '$monthName $year';
    } else {
      // Jika input tidak valid
      return 'Belum Diselesaikan';
    }
  }

  String removeMultiSpace(String input){
    return input.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}