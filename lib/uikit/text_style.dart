import 'package:flutter/material.dart';

class CustomTextStyle {
  CustomTextStyle._();

  static const String fontFamily = 'FiraSans';

  // Título maior
  static const TextStyle title1 = TextStyle( 
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  //Título menor
  static const TextStyle title2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  // Parágrafo maior
  static const TextStyle body1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  // Parágrafo menor
  static const TextStyle body2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  // botão
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  // ícone
  static const TextStyle icon = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // ícone selecionado
  static const TextStyle iconSelected = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );
}