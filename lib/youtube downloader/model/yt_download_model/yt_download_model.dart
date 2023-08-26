


import 'audio_model.dart';
import 'mp4_model.dart';

class YtDownloadModelFields{
  static const String creator="creator";
  static const String pilihan_type="pilihan_type";
  static const String id="id";
  static const String thumbnail="thumbnail";
  static const String title="title";
  static const String mp4="mp4";
  static const String audio="audio";
}


class YtDownloadModel{
  String creator;
  String pilihan_type;
  String id;
  String thumbnail;
  String title;
  Mp4Model mp4;
  AudioModel audio;

  YtDownloadModel({
   required this.creator,
   required this.pilihan_type,
   required this.id,
   required this.thumbnail,
   required this.title,
   required this.mp4,
   required this.audio
});

  factory YtDownloadModel.fromJson(Map<String,dynamic> json)=>YtDownloadModel(
      creator: json[YtDownloadModelFields.creator],
      pilihan_type: json[YtDownloadModelFields.pilihan_type],
      id: json[YtDownloadModelFields.id],
      thumbnail: json[YtDownloadModelFields.thumbnail],
      title: json[YtDownloadModelFields.title],
      mp4: Mp4Model.fromJson(json[YtDownloadModelFields.mp4]),
      audio: AudioModel.fromJson(json[YtDownloadModelFields.audio])
  );

}