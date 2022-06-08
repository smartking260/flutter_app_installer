import 'dart:io';
import 'package:app_installer/app_installer.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:file_utils/file_utils.dart';
import 'dart:math';

import 'package:permission_handler/permission_handler.dart';

void main() => runApp(Downloader());

class Downloader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "File Downloader",
        debugShowCheckedModeBanner: false,
        home: FileDownloader(),
        theme: ThemeData(primarySwatch: Colors.blue),
      );
}

class FileDownloader extends StatefulWidget {
  @override
  _FileDownloaderState createState() => _FileDownloaderState();
}

class _FileDownloaderState extends State<FileDownloader> {
  final url = "https://github.com/smartking260/test/raw/main/testy.msix";
  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  var _onPressed;
  static final Random random = Random();
  Directory? externalDir;

  @override
  void initState() {
    super.initState();
    _onPressed = () {
      downloadFile();
    };
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    var status = await Permission.storage.request();
    bool isGranted = Platform.isWindows ? true : status.isGranted;
    if (isGranted) {
      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      var randid = random.nextInt(10000);

      try {
        FileUtils.mkdir([dirloc]);
        final response = await dio.download(url, dirloc + "testy" + ".msix",
            onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            downloading = true;
            progress =
                ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%";
            if (progress == "100%") {
              progress = "Download Completed.";
              // NextAction();
            }
          });
        });
      } catch (e) {
        print(e);
      }

      setState(() async {
        downloading = false;

        path = dirloc + "testy" + ".msidfdf";
        try {
          await installApp(path);
        } catch (error) {
          print(error);
        }
      });
    } else {
      setState(() {
        progress = "Permission Denied!";
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('File Downloader'),
      ),
      body: Center(
          child: downloading
              ? Container(
                  height: 120.0,
                  width: 200.0,
                  child: Card(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Downloading File: $progress',
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(path),
                    MaterialButton(
                      child: Text('download'),
                      onPressed: _onPressed,
                      disabledColor: Colors.blueGrey,
                      color: Colors.green,
                      textColor: Colors.white,
                      height: 40.0,
                      minWidth: 100.0,
                    ),
                  ],
                )));
}
