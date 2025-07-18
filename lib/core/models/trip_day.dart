
class TripDay {
  final String date;
  final String summary;
  final List<TripItem> items;

  TripDay({required this.date, required this.summary, required this.items});

  factory TripDay.fromJson(Map<String, dynamic> json) {
    return TripDay(
      date: json['date'],
      summary: json['summary'],
      items: (json['items'] as List)
          .map((item) => TripItem.fromJson(item))
          .toList(),
    );
  }
}

class TripItem {
  final String time;
  final String activity;
  final String location;

  TripItem({required this.time, required this.activity, required this.location});

  factory TripItem.fromJson(Map<String, dynamic> json) {
    return TripItem(
      time: json['time'],
      activity: json['activity'],
      location: json['location'],
    );
  }
}