



import 'package:aiodownloader/youtube%20downloader/screens/downloader_screen.dart';
import 'package:flutter/material.dart';

import '../../app theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3),(){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>YoutubeDownloaderPage()) ,(route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.orange,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            FadeInImage(
              width: 200,
              height: 200,
              fadeInCurve:Curves.easeInCirc,
              fadeInDuration: Duration(seconds: 1),
            fadeOutDuration: Duration(seconds: 1),
            placeholder: AssetImage('assets/images/app_icon.png'),
            image: AssetImage('assets/images/splash_icon.png')
            ),


            // Container(
            //   decoration: const BoxDecoration(
            //
            //       image: DecorationImage(
            //         image: AssetImage('assets/images/splash_icon.png'))
            //   ),
            //   child: SizedBox(
            //     height: 200,
            //     width: 200,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
