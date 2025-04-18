class ParsingTools {
  String parseSummary(List<String> input) {
    String output = input.isEmpty ? "no title given" : input.join(" ").trim();
    output = (output == "") ? "no title given" : output;
    return output;
  }

  String parseDescription(List<String> input) {
    return input.join(" ");
  }

  String parseLocation(List<String> locations) {
    String location = locations.isEmpty ? "no location given" : locations.join(" ").trim();
    return (location == "") ? "no location given" : location;
  }

  String parseTime(List<List<String>> input, bool start) {
    Map<String, int> DAYS = {"Mo": 0, "Tu": 1, "We": 2, "Th": 3, "Fr": 4};
    Map<String, int> NUM_DAYS_IN_MONTH = {"01": 31, "02": 28, "03": 31, "04": 30, "05": 31, "06": 30, "07": 31, "08": 31, "09": 30, "10": 31, "11": 30, "12": 31};

    if (input.isEmpty) {
      return "";
    }
    String date = parseStartDate(input[0]);

    String startDay = parseMeetingDays(input[2][0])[0]; // "Mo"

    List<String> dateParts = date.split('-').toList();
    String year = dateParts[0];
    String month = dateParts[1];
    String day = dateParts[2];

    int? numDaysDifferent = DAYS[startDay]; // The number of days between the first class date and the semester start date assuming semester start date is monday
    int dayInt = int.parse(day);

    int adjustedDayInt = dayInt + (numDaysDifferent ?? 0);

    int numDaysInMonth = NUM_DAYS_IN_MONTH[month] ?? 28;
    if (month == "02" && (int.parse(year) % 4 == 0)) numDaysInMonth++; // If it's a leap year (year is multiple of 4), add one day to Feb

    if (adjustedDayInt > numDaysInMonth) {
      int adjustedMonthInt = (int.parse(month) + 1) % 12;
      adjustedDayInt = adjustedDayInt % (NUM_DAYS_IN_MONTH[month] ?? 28);
      if (adjustedMonthInt < 10) {
        month = "0$adjustedMonthInt";
      } else {
        month = "$adjustedMonthInt";
      }
    }

    if (adjustedDayInt < 10) {
      day = "0$adjustedDayInt";
    } else {
      day = "$adjustedDayInt";
    }
    date = "$year-$month-$day";
    String output = "${date}T";

    if (input[1][0] == "") {
      //return output;
      return start ? "${output}00:00" : "${output}01:00"; // Default start and end time
    }

    List<String> timeList = input[1][0].trim().split('-').toList(); // [ "01:23 am" , "12:12 pm" ]
    if (start) { // Parse start time
      output += parseStartTime(timeList[0]); // output += parseStartTime("01:23 am")
    } else if (!start) { // Parse end time
      output += parseEndTime(timeList[1]); // output += parseEndTime("12:12 pm")
    }

    return output; // "12-25-2025T01:23"
  }

  String parseStartTime(String input) {

    if(input.isEmpty) {
      return "00:00"; // Default start time
    }

    List<String> timeParts = input.trim().split(' ').toList(); // [ "01:23" , "am" ]
    String timeShort = timeParts[0]; // "01:23"
    String mornAft = timeParts[1]; // "am"

    List<String> minHour = timeShort.trim().split(':').toList(); // [ "01" , "23" ]
    int hourInt = int.parse(minHour[0]); // 1
    String minute = minHour[1]; // 23

    bool afternoon = mornAft == "pm";

    if (afternoon && hourInt != 12) {
      hourInt += 12;
    }
    String hour = "$hourInt";
    if (hourInt < 10) {
      hour = "0$hour"; // "01"
    }

    return "$hour:$minute"; // "12-25-2025T" + "01:23" = "12-25-2025T01:23"
  }

  String parseStartDate(List<String> input) {
    List<String> dates = input[0].trim().split('-');

    String startDate = dates[0];
    List<String> dateParts = startDate.trim().split('/').toList();

    String startMonth = dateParts[0];
    String startDay = dateParts[1];
    String startYear = dateParts[2];
    return "$startYear-$startMonth-$startDay";
  }

  List<String> parseMeetingDays(String input) {
    if (input == "") {
      return [""];
    }
    List<String> output = RegExp(r'(Mo|Tu|We|Th|Fr|Sa|Su)', caseSensitive: false).allMatches(input).map((match) => match.group(0)!).toList();
    return output;
  }
    
  String parseEndTime(String input) {

    if(input.isEmpty) {
      return "01:00"; // Default end time
    }

    List<String> timeParts = input.trim().split(' ').toList(); // [ "12:12" , "pm" ]
    String timeShort = timeParts[0]; // "12:12"
    String mornAft = timeParts[1]; // "pm"

    List<String> minHour = timeShort.trim().split(':').toList(); // [ "12" , "12" ]
    int hourInt = int.parse(minHour[0]); // 12
    String minute = minHour[1]; // 12

    bool afternoon = mornAft == "pm";

    if (afternoon && hourInt != 12) {
      hourInt += 12; // 24
    }
    String hour = "$hourInt"; // "24"
    if (hourInt < 10) {
      hour = "0$hour"; 
    }

    return "$hour:$minute"; // "12-25-2025T" + "24:12" = "12-25-2025T24:12"
  }

  String parseEndDate(List<String> input) {
    List<String> dates = input[0].trim().split('-');

    String endDate = dates[1];
    List<String> dateParts = endDate.trim().split('/').toList();

    String month = dateParts[0];
    String day = dateParts[1];
    String year = dateParts[2];
    return "$year$month$day";
  }

  String parseTimezone(List<String> input) {
    // TODO potentially find a way to get timezone later, for now hard code Denver
    return "America/Denver";
  }

  List<String> parseRecurrenceRules(List<List<String>> input) {
    List<String> output = [];
    String rule = 'RRULE:FREQ=WEEKLY;BYDAY=';

    String meetingDays = parseMeetingDays(input[0][0]).join(',');
    if (meetingDays == "") {
      //return [];
      final endDate = parseEndDate(input[1]);
      return ['RRULE:FREQ=WEEKLY;BYDAY=Mo;UNTIL=${endDate}T235959Z'];
    }
    rule += meetingDays;
    rule += ';UNTIL=';
    rule += parseEndDate(input[1]);
    rule += "T235959Z";

    output.add(rule);
    return output;
  }

  bool parseGraduateLevel(List<String> input) {
    return int.parse(input.isEmpty ? "000" : input.join(" ").trim()) >= 500;
  }
}