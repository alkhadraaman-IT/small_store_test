class Announcement {
  final int id;
  final int store_id ;
  final String announcement_description;
  final String announcement_date ;
  final bool announcement_state;
  final String announcement_photo;

  Announcement({
    required this.id,
    required this.store_id ,
    required this.announcement_description,
    required this.announcement_date,
    required this.announcement_state ,
    required this.announcement_photo ,
  });

  // Factory method to convert JSON to Product object
  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      store_id: json['store_id'],
      announcement_description: json['announcement_description'],
      announcement_date: json['announcement_date'],
      announcement_state: json['announcement_state'],
      announcement_photo: json['announcement_photo'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': store_id,
      'announcement_description': announcement_description,
      'announcement_date': announcement_date,
      'announcement_state': announcement_state,
      'announcement_photo': announcement_photo,
    };
  }
}
