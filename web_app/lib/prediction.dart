import 'package:flutter/material.dart';


class CyclePredictor {

  static const int maxCycleLength = 99;
  static const int defaultCycleLength = 28;
  static const int averageMin = 21;
  static const int averageMax = 39;
  static const int endOfAlertDays = 3;
  static const int regularCycleRangeMin = 26;
  static const int regularCycleRangeMax = 32;
  static const int fertileWindowStart = 8;
  static const int fertileWindowEnd = 19;
  static const int beepAlertOn = 8;
  static const int beepAlertOff = 20;
  static const int averageWindow = 3;

  int predictLength(List pastCycleLengths) {
    if (pastCycleLengths.isEmpty) {
      return defaultCycleLength;
    }
    else if (pastCycleLengths.length < averageWindow) {
      int listLength = pastCycleLengths.length;
      return (pastCycleLengths.reduce((a,b)=>a+b) / listLength).round();
    }
    else {
      int listLength = pastCycleLengths.length;
      List windowedList = pastCycleLengths.sublist(listLength-averageWindow, listLength);
      return (windowedList.reduce((a,b)=>a+b) / averageWindow).round();
    }
  }
}
