import "package:flutter/material.dart";
import "package:intl/intl.dart";

String parseEnumString(String page) => page.split(".")[1];

bool isSame(String pageName, String pageNameEnum) =>
    pageName == parseEnumString(pageNameEnum);

const Map<String, dynamic> categories = {
  "Entertainment": Icons.gamepad,
  "Gift": Icons.card_giftcard,
  "Hostel": Icons.hotel,
  "Meal": Icons.restaurant,
  "School": Icons.school,
  "Shopping": Icons.shopping_cart,
  "Transportation": Icons.directions_subway,
  "Work": Icons.work,
  "Others": Icons.folder,
};

IconData getCategoryIcon(String iconString) => categories[iconString];
