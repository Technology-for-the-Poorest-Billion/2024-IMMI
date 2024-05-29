import 'utils.dart';


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
  static const double smoothingFactor = 0.1;
  static const String averageMethod = 'ma';

  int movingAverage(List pastData) {
    if (pastData.length < averageWindow) {
      int listLength = pastData.length;
      return (pastData.reduce((a,b)=>a+b) / listLength).round();
    }
    else {
      int listLength = pastData.length;
      List windowedList = pastData.sublist(listLength-averageWindow, listLength);
      return (windowedList.reduce((a,b)=>a+b) / averageWindow).round();
    }
  }

  int predictLength(List pastCycleLengths) {
    if (pastCycleLengths.isEmpty) {
      return defaultCycleLength;
    }
    else {
      if(averageMethod == 'ma') {
        return movingAverage(pastCycleLengths);
      }
      else {
        return 0;
      }
    }
  }

  bool fertilityCheck(List pastCycleStartDates) {
    DateTime now = DateTime.now();
    DateTime thisCycleStartDate = DateTime.parse(pastCycleStartDates[pastCycleStartDates.length-1]);
    int dayInCycle = now.difference(thisCycleStartDate).inDays;

    if((dayInCycle >= fertileWindowStart) && (dayInCycle <= fertileWindowEnd)) {
      return true;
    }
    return false;
  }
}

bool checkRepeatedEntry(String newEntryDate, List pastEntryDates) {
  if(newEntryDate == pastEntryDates[pastEntryDates.length-1]) {
    return true;
  }
  return false;
}

bool checkPrecededEntry(String cycleStartDate, List pastCycleStartDates) {
  if(cycleStartDate == pastCycleStartDates[pastCycleStartDates.length-1]) {
    return true;
  }
  return false;
}

void main() {
  var pastData = const <String, List> {
    'cycleLengths': [1, 2],
    'cycleStartDates': ['a', 'b'],
    'entryDates': ['x', 'y']
  };

  List x = List.from(pastData['cycleLengths'] as List);
  print(x);
}
