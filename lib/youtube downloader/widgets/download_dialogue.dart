

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/yt_downloader_provider.dart';

showDownloadProgressDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (_) {
      return CupertinoAlertDialog(
        content: Consumer<YtDownloaderProvider>(
          builder: (context, provider, child) {
            if (provider.status == DownloadTaskStatus.STARTING) {
              return Center(child: Text("Starting Download..."));
            } else if (provider.status == DownloadTaskStatus.DOWNLOADING) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Positioned(
                    right: 5,
                    child: Text("${provider.percent.toStringAsFixed(2)}%"),
                  ),
                ],
              );
            } else if (provider.status == DownloadTaskStatus.FAILED) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 16),
                  Expanded(child: Text('Failed to save: Permission denied')),
                ],
              );
            } else {
              print(provider.downloadedFile!.path);
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 16),
                  Text('Done Downloading'),
                ],
              );
            }
          },
        ),
      );
    },
  );
}
