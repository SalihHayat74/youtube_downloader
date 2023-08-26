



class Mp4ModelFields{
  static const String download="download";
  static const String size="size";
  static const String type_download="type_download";
}

class Mp4Model{
  String download;
  String size;
  String type_download;

  Mp4Model({
   required this.download,
   required this.size,
   required this.type_download
});

  factory Mp4Model.fromJson(Map<String,dynamic> json)=>Mp4Model(
      download: json[Mp4ModelFields.download],
      size: json[Mp4ModelFields.size],
      type_download: json[Mp4ModelFields.type_download]);


}