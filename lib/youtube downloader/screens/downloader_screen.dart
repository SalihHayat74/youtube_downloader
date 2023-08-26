import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'package:aiodownloader/app%20theme/app_theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/drawer.dart';
import '../constants/constants.dart';
import '../provider/yt_downloader_provider.dart';
import '../utils/injector.dart';

class YoutubeDownloaderPage extends StatefulWidget {
  // YoutubeDownloaderPage({required Key key}) : super(key: key);

  @override
  State<YoutubeDownloaderPage> createState() => _YoutubeDownloaderPageState();
}

class _YoutubeDownloaderPageState extends State<YoutubeDownloaderPage> {


  Directory? directory =Directory('/storage/emulated/0/Download/');
  // String directory;
  // List file =[];


  String videoQualityType = '360';

  // List of items in our dropdown menu


  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {

      });
    });
    super.initState();
  }

  Timer?  timer;
  ///**********************************************************
  /// Getting Directory files which was downloaded by this app
  ///**********************************************************

  TextEditingController _urlController = TextEditingController();
  bool isLoading=false;
  bool searchVisible=false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    var provider=Provider.of<YtDownloaderProvider>(context);
    var updateProvider=Provider.of<YtDownloaderProvider>(context,listen: false);
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   leading: Image.asset('assets/images/app_icon.png'),
      //   title: const Text('AIO Downloader'),
      // ),
      drawer: const CustomDrawer(),
      body: Container(
        height: height,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: AppTheme.mainThemeColor
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: width*.85,top: height*.05),
              child: IconButton(
                  onPressed: (){
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  icon: Icon(Icons.menu)),
            ),
            Expanded(
              // height: height*.6,
              child: SingleChildScrollView(
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/app_icon.png',
                    height: 100,
                      width: 100,
                    ),
                    Text("AIO Downloader",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          suffixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                                color: Colors.black),
                            borderRadius: BorderRadius.circular(24)
                          ),
                          hintText: 'Paste Youtube Video link here...',

                        ),
                        // onSubmitted: (url) => searchData(url),
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*.6,
                          child: Row(
                            children: [
                              const Text("Choose Video Quality",textAlign: TextAlign.center,),
                              PopupMenuButton(
                                icon: const Icon(Icons.arrow_drop_down),
                                splashRadius: 20,
                                itemBuilder: (context)=>[
                                  const PopupMenuItem(
                                      value: 1,
                                      child: Text("144 p")),
                                  const PopupMenuItem(
                                      value: 2,
                                      child: Text("240 p")),
                                  const PopupMenuItem(
                                      value: 3,
                                      child: Text("360 p")),
                                  const PopupMenuItem(
                                      value: 4,
                                      child: Text("480 p")),
                                  const PopupMenuItem(
                                      value: 5,
                                      child: Text("720 p")),
                                  const PopupMenuItem(
                                      value: 6,
                                      child: Text("1080 p"))
                                ],
                                onSelected: (value){
                                  value==1?videoQualityType='144':
                                  value==2?videoQualityType='240':
                                  value==3?videoQualityType='360':
                                  value==4?videoQualityType='480':
                                  value==5?videoQualityType='720':
                                  videoQualityType='1080';
                                  setState(() {
                                    searchVisible = true;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        Visibility(
                          visible: searchVisible,
                          child: InkWell(
                            onTap: () async{
                              FocusScope.of(context).unfocus();
                              if(_urlController.text.isEmpty){
                                EasyLoading.showToast("Link is required",toastPosition: EasyLoadingToastPosition.bottom);
                              }else if(!_urlController.text.contains('you') &&
                              !_urlController.text.contains('.com')
                              ){
                                EasyLoading.showToast("Invalid link",toastPosition: EasyLoadingToastPosition.bottom);
                              }else{

                                if(_urlController.text.contains('youtu.be')){
                                  _urlController.text=_urlController.text.replaceAll('youtu.be/', 'www.youtube.com/watch?v=');
                                }
                                String url='${ApiConstants.ytUrl}${_urlController.text}&type=$videoQualityType';

                                await updateProvider.getDownloadVideo(url);
                              }


                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: MediaQuery.of(context).size.width*.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(),
                                boxShadow: const [
                                  BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    color: Colors.grey
                                  )
                                ],
                                gradient: const RadialGradient(
                                    radius: 3,
                                    colors: [
                                      Colors.white,
                                  Colors.orange,

                                ])
                              ),
                              child: Text("Search $videoQualityType P"),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          provider.ytDownloadInstance==null?
                            const SizedBox():(
                              FadeInImage.assetNetwork(
                              placeholder: 'assets/images/app_icon.png',
                              image: provider.ytDownloadInstance!.thumbnail,
                            height: 150,
                            width: 150,
                          )
                          ),
                         // Image.network(thumbb),
                          // FadeInImage.assetNetwork(
                          //   placeholder: 'assets/images/placeholder.png',
                          //   image: thumbb,
                          //   height: 150,
                          //   width: 350,
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            provider.ytDownloadInstance == null
                                ? ''
                                : 'Title: ${provider.ytDownloadInstance!.title}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: provider.ytDownloadInstance == null
                                ? false
                                : true,
                            child: TextButton(
                              style: ButtonStyle(
                                padding:
                                MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(15),
                                ),
                                foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.red),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              onPressed:  () {
                                provider.downloadFile(context:context,fileExtension: '.mp3');
                              },
                              child: Text(
                                provider.ytDownloadInstance!=null && provider.isDownloadingMp3==true
                                    ? 'Downloading...'
                                    : "Download MP3 (${provider.ytDownloadInstance?.audio.size})"
                                    .toUpperCase(),
                                style: const TextStyle(fontSize: 14,color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: provider.ytDownloadInstance==null
                                ? false
                                : true,
                            child: TextButton(
                              style: ButtonStyle(
                                padding:
                                MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(15),
                                ),
                                foregroundColor:
                                MaterialStateProperty.all<Color>(
                                    Colors.red),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.0),
                                    side: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              onPressed: provider.ytDownloadInstance==null
                                  ? null
                                  : () {
                                provider.downloadFile(context:context,fileExtension: '.mp4');
                              },
                              child: Text(
                                provider.ytDownloadInstance!=null && provider.isDownloadingMp4==true
                                    ? 'Downloading...'
                                    : "Download MP4 (${provider.ytDownloadInstance?.mp4.type_download} P, ${provider.ytDownloadInstance?.mp4.size})"
                                    .toUpperCase(),
                                style: const TextStyle(fontSize: 14,color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Text("Status: ${provider.status}"),
                          provider.ytDownloadInstance!=null?
                          Text("Downloaded: ${provider.downloaded} / Total: ${provider.ytDownloadInstance!.mp4.size}"):
                          Text(''),
                          const SizedBox(
                            height: 10,
                          ),
                          provider.ytDownloadInstance!=null?Text("Speed: ${provider.downloadSpeed} Kbps"):Text(""),
                          const SizedBox(
                            height: 10,
                          ),
                          provider.status==DownloadTaskStatus.DOWNLOADING?
                          LinearPercentIndicator(

                           progressColor: provider.percent<25?Colors.red:
                           provider.percent<50&& provider.percent>25?Colors.redAccent:
                           provider.percent>50 && provider.percent<75?Colors.yellowAccent:
                           Colors.green,
                            backgroundColor: Colors.white,
                            percent: provider.percent.toDouble()/100,
                            lineHeight: 20,
                            center: Text('${provider.percent} %',style: TextStyle(
                                color: provider.percent>=75?Colors.white:Colors.red),),


                          ):
                          SizedBox()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}