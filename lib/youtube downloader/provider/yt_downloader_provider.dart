


import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:http/http.dart'as http;
import '../model/yt_download_model/yt_download_model.dart';
import '../repository/api_repo.dart';
import '../utils/injector.dart';

enum DownloadTaskStatus {
  STARTING,
  DOWNLOADING,
  DONE,
  FAILED,
}

class YtDownloaderProvider extends ChangeNotifier{

  YtDownloadModel? ytDownloadInstance;
  Directory? downloadDirectory;
  String progress='0.0';
  bool isSearching=false;
  bool isDownloadingMp3=false;
  bool isDownloadingMp4=false;
  double downloadSpeed=0.0;
  double downloaded=0.0;


  int percent = 0;
  DownloadTaskStatus status = DownloadTaskStatus.STARTING;
  File? downloadedFile;
  String folderName = 'My HTTP Folder';		// Change to suit the task at hand

  Future<void> downloadFile({
    required BuildContext context,
    String fileExtension = ".mp4",

  }) async {
    // Reset the vars from previous task.

    status = DownloadTaskStatus.STARTING;
    percent = 0;
    downloadedFile = null;

    // showDownloadProgressDialog(context);

    var httpClient = http.Client();
    Request ? request;
    if(fileExtension=='.mp4'){
      request = http.Request('GET', Uri.parse(ytDownloadInstance!.mp4.download));
    }else{
      request = http.Request('GET', Uri.parse(ytDownloadInstance!.audio.audio));
    }

    var response = httpClient.send(request);
    // This will only work on Android.
    // Use path_provider when platform is iOS.
    // Directory directory = Directory("/storage/emulated/0/$folderName");

    List<List<int>> chunks = [];
    await getDownloadPath();
    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {
        // Stream has started emitting
        // Download task has began

        status = DownloadTaskStatus.DOWNLOADING;
        print(status);
        print(chunks.length);
        Timer.periodic(Duration(seconds: 1), (timer) {
          downloadSpeed=chunk.length.toDouble();
        });

        print(downloadSpeed);
        // Display percentage of completion
        debugPrint('downloadPercentage: ${downloaded / r.contentLength! * 100}');

        chunks.add(chunk);

        downloaded += chunk.length;
        percent = (downloaded / r.contentLength! * 100).ceil();

        notifyListeners();
      }, onDone: () async {
        // Display percentage of completion
        debugPrint('downloadPercentage: ${downloaded / r.contentLength! * 100}');
        downloadDirectory!.createSync(recursive: true);

        // Save the file
        File file =await File('${downloadDirectory!.path}/AIO Downloader/yt/${ytDownloadInstance!.title.substring(0,30).replaceAll(' ', '_')}$fileExtension').create(recursive: true);
        print(file.path);
        final Uint8List bytes = Uint8List(r.contentLength!);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }

        try {
          await file.writeAsBytes(bytes);
        } on FileSystemException catch (e) {
          print(e.path);
          status = DownloadTaskStatus.FAILED;

          notifyListeners();
          print(e.message);
          return;
        }

        // Set status to done
        status = DownloadTaskStatus.DONE;
        downloadedFile = file;
        print(status);


        notifyListeners();

      });
    });
  }


  startSearching(){
    isSearching=true;
    notifyListeners();
  }
  stopSearching(){
    isSearching=false;
    notifyListeners();
  }
  getDownloadVideo(String url)async{
    EasyLoading.show(status: "Searching");
    http.Response? response=await ApiRepository().getData(url);
    if(response!=null) {
      ytDownloadInstance=YtDownloadModel.fromJson(jsonDecode(response.body));
    }else{
      EasyLoading.showError("Video not found in selected format",duration: const Duration(milliseconds: 3000));
    }
    EasyLoading.dismiss();
    notifyListeners();
  }

  getDownloadPath() async {

    try {
      if (Platform.isIOS) {
        downloadDirectory = await getApplicationDocumentsDirectory();
      } else {
        downloadDirectory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await downloadDirectory!.exists()) {
          downloadDirectory = await getExternalStorageDirectory();
        }
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    notifyListeners();
  }

  // Future<void> downloadVideo({required String fileFormat}) async {
  //
  //   try {
  //     var status = await Permission.manageExternalStorage.request();
  //
  //     if(!status.isGranted){
  //       openAppSettings();
  //       // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
  //     } else if(status.isPermanentlyDenied){
  //       openAppSettings();
  //     }
  //
  //     await getDownloadPath();
  //
  //     String videoTitle = ytDownloadInstance!.title.substring(0,30);
  //
  //     await dio.download(ytDownloadInstance!.mp4.download, "${downloadDirectory?.path}/AIO Downloader/Yt Download/$videoTitle$fileFormat",
  //         options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),
  //         onReceiveProgress: (received, total) {
  //
  //           double doubleTotalMp3=0.0;
  //           double doubleTotalMp4 = 0.0;
  //           if(total == -1){
  //             if(ytDownloadInstance!.audio.size.contains('KB')){
  //               isDownloadingMp3=true;
  //               doubleTotalMp3 = double.parse(ytDownloadInstance!.audio.size.replaceAll('KB', ''));
  //               if(fileFormat=='.mp3'){
  //                   progress = "${(((received/1024 ) / (doubleTotalMp3)) * 100).toStringAsFixed(1)}%";
  //                   notifyListeners();
  //               }
  //             }
  //             if(ytDownloadInstance!.audio.size.contains('MB')){
  //               isDownloadingMp3=true;
  //               doubleTotalMp3 = double.parse(ytDownloadInstance!.audio.size.replaceAll('MB', ''));
  //               if(fileFormat=='.mp3'){
  //
  //                   progress = "${(((received/102400 ) / doubleTotalMp3) * 100).toStringAsFixed(1)}%";
  //
  //                   if(received/doubleTotalMp3 >= 1){
  //                     // downloadCompleted=true;
  //                     // receivedDownloadSize = (doubleTotalMp3).toStringAsFixed(2);
  //                     // totalDownloadSize = (doubleTotalMp3).toStringAsFixed(2);
  //                   }
  //
  //
  //
  //
  //               }
  //             }
  //             if(ytDownloadInstance!.audio.size.contains('GB')){
  //               isDownloadingMp3=true;
  //               doubleTotalMp3 = double.parse(ytDownloadInstance!.audio.size.replaceAll('GB', ''));
  //               if(fileFormat=='.mp3'){
  //                   progress = "${(((received ) / doubleTotalMp3) * 100).toStringAsFixed(0)}%";
  //                   notifyListeners();
  //               }
  //             }
  //             // total = total ;
  //
  //             if(fileFormat=='.mp4')
  //               print(total);
  //           }else{
  //             // doubleTotalMp3 = double.parse(sizeInMp3.replaceAll('KB', ''));
  //             if(fileFormat=='.mp3'){
  //
  //                 progress = "${((received / total) * 100).toStringAsFixed(0)}%";
  //                 notifyListeners();
  //
  //
  //             }
  //             if(fileFormat=='.mp4'){
  //               isDownloadingMp4=true;
  //               print("I am total not=1 and mp4");
  //               print(received);
  //               if(ytDownloadInstance!.mp4.size.contains('KB')){
  //
  //                   print(received);
  //                   progress = "${((received / total) * 100).toStringAsFixed(1)}%";
  //                  notifyListeners();
  //
  //               }
  //               if(ytDownloadInstance!.mp4.size.contains('MB')){
  //
  //
  //                   progress = "${((received / total) * 100).toStringAsFixed(1)}%";
  //                   notifyListeners();
  //
  //               }
  //               if(ytDownloadInstance!.mp4.size.contains('GB')){
  //
  //
  //                   progress = "${((received / total) * 100).toStringAsFixed(0)}%";
  //                   notifyListeners();
  //
  //               }
  //
  //
  //
  //
  //             }
  //           }
  //
  //
  //
  //
  //           // setState(() {
  //           //     progress = "${((received / total) * 100).toStringAsFixed(0)}%";
  //           //     receivedDownloadSize = (received).toStringAsFixed(1);
  //           //     totalDownloadSize = (total).toStringAsFixed(1);
  //           //     if(received/total >= 1){
  //           //       downloadCompleted=true;
  //           //     }
  //           //   });
  //
  //         });
  //
  //
  //   } catch (e) {
  //    print(e);
  //   }
  // }

}