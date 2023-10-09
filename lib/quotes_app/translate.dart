import 'package:flutter/material.dart';

import 'package:translator/translator.dart';

final translator = GoogleTranslator();
String languageCode = "en";

Future textTranslate({
  input,
  language,
}) async {
  dynamic res;

  await translator
      .translate(
    input,
    to: languageCode,
    from: language?? "en",
  )
      .then(
        (result) {
      res = result;
    },
  );

  return res;
}

textToTrans({
  @required String? input,
  style,
  TextOverflow? overflow,
  int? maxLines,
  TextAlign? textAlign,
  double? height,
  double? width,
  bool isCenterSimmer = false,
  bool isCenterText = false,
  String? language, bool? softWrap,
}) {
  return FutureBuilder(
    future: textTranslate(
      input: input,
      language: language,
    ),
    builder: (
        _,
        s,
        ) {
      if (s.hasData) {
        return Text(
          "${s.data}",
          style: style,
          maxLines: maxLines,
          textAlign: isCenterText ? TextAlign.center : TextAlign.start,
          overflow: overflow ?? TextOverflow.visible,
        );
      } else {
        return Text(
          "...",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        );
      }
    },
  );
}
