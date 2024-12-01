class Data {
  final String id;
  final String location;
  final String time;
  final String ipaddress;
  var date;
  Data({
    required this.id,
    required this.location,
    required this.time,
    required this.ipaddress,
    required this.date,
  });

  // Factory method to create a Contact object from a Firestore document
  factory Data.fromDocument(Map<String, dynamic> doc, String id) {
    return Data(
        date: doc['date'],
        id: id,
        location: doc['location'] ?? '',
        time: doc['time'] ?? '',
        ipaddress: doc['ipaddress'] ?? '');
  }
}
