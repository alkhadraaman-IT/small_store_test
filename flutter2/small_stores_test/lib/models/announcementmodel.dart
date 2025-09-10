class Announcement {
  final int id;
  final int store_id ;
  final String announcement_description;
  final String announcement_date ;
  final int announcement_state;
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
    final annData = json['data'] ?? json;

    return Announcement(
      id: annData['id'],
      store_id: annData['store_id']is String?int.parse(annData['store_id'])
          : annData['store_id'],
      announcement_description: annData['announcement_description'],
      announcement_date: annData['announcement_date'],
      announcement_state: annData['announcement_state'] is String
          ? int.parse(annData['announcement_state'])
          : annData['announcement_state'],
      announcement_photo: annData['announcement_photo'] ,
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
