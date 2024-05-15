import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../color_asset/colors.dart';

void justConfirmDialog({
  required BuildContext context,
  String? title,
  String? description,
  }){
  showDialog(context: context, 
    builder: (context){
      return AlertDialog(
        title: title == null ? null : Text(title,
          style: GoogleFonts.notoSans(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        content: description == null ? null : Text(description,
          style: GoogleFonts.notoSans(
            fontSize: 18
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("확인",
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: CsColors.cs.accentColor
              ),
            ),
          )
        ],
      );
    }
  );
}
