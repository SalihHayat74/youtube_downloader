


class AudioModelFields{
  static const String audio="audio";
  static const String size="size";
}

class AudioModel{
  String audio;
  String size;

  AudioModel({
    required this.audio,
    required this.size
});

  factory AudioModel.fromJson(Map<String,dynamic> json)=>AudioModel(
      audio: json[AudioModelFields.audio]??'',
      size: json[AudioModelFields.size]??''
  );

}