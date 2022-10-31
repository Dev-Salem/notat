class Note {
  final String document;
  final String title;
  final String folder;
  final DateTime date;
  final String uid;
  final String
      searchableDocument; //This was originally created to allow search function
  Note(
      {required this.document,
      required this.searchableDocument,
      required this.title,
      required this.folder,
      required this.date,
      required this.uid});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'folder': folder,
      'date': date,
      'uid': uid,
      'document': document,
      'searchableDocument': searchableDocument,
    };
  }
}
