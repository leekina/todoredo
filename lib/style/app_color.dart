import 'package:flutter/material.dart';

enum ThemeColor {
  pink("핑크", Colors.pink),
  purple("퍼플", Colors.purple),
  orange("오렌지", Colors.orange),
  brown("브라운", Colors.brown),
  blue("블루", Colors.blue),
  green("그린", Colors.green),
  ;

  final String name;
  final Color color;

  const ThemeColor(this.name, this.color);
}


//   classicBlue("클래식 블루", Color(0xff0f4c81)),
//   emerald("에메랄드", Color(0xff009473)),
//   greenery("그리너리", Color(0xff88b04b)),
