import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/core_packages.dart';

Color kPrimary = Color(0xFF30115b);
Color kSecondary = Color(0XFFB22F4A);
Color kTextColor = Colors.black;

Color kWhite = Color(0xFFE0E0E0);
Color kError = Colors.red;
Color kGrey = Colors.grey;

Color kPersonal = Color(0xFFf77b67);
Color kWork = Color(0xFF5a89e6);
Color kBucket = Color(0xFF4ec5ac);

double kExtraExtraSmall = 8;
double kExtraSmall = 12;
double kSmall = 16;
double kMedium = 24;
double kLarge = 32;
double kExtraLarge = 48;
double kExtraExtraLarge = 64;

TextStyle kHeader = GoogleFonts.inter(fontSize: kLarge + 4, fontWeight: FontWeight.w600, color: kWhite);
TextStyle kSubHeader =
    GoogleFonts.inter(fontSize: kSmall + 4, fontWeight: FontWeight.w600, color: kWhite.withOpacity(.8));
TextStyle kCaption = GoogleFonts.inter(fontSize: kExtraSmall, fontWeight: FontWeight.w800, color: kTextColor);
TextStyle kBodyText = GoogleFonts.inter(fontSize: kSmall, fontWeight: FontWeight.w500, color: kTextColor);
TextStyle kButton = GoogleFonts.inter(fontSize: kSmall, fontWeight: FontWeight.w600, color: kWhite);
TextStyle kGreyText = GoogleFonts.inter(fontSize: kExtraSmall + 2, color: kGrey);
