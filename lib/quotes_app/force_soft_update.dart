import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quotes_app/quotes_app/flutter_toast.dart';
import 'package:quotes_app/quotes_app/home_screen.dart';
import 'package:quotes_app/quotes_app/permission.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  bool get = false;
  Map quotes = {};
  Map data = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2),(){
      getApi();
    });
    // getApi();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: /*Image.network(
            "https://m.media-amazon.com/images/I/51jqacDO3DL.png",height: 180,width: 180,),*/
        Lottie.asset("asset/image/animation_lnbp6elv.json"),
      ),
    );
  }

  void getApi() async {
    final prefs = await SharedPreferences.getInstance();
    get = true;
    setState(() {});

    http.Response response = await http.get(
      Uri.parse(
          "https://development.frontbitsolutions.com/my_api/api.php?package_name=com.google.android.apps.nbu.paisa.user&api_key=quotes"),
    );
    debugPrint("Status Code = ${response.statusCode}");
    debugPrint("Body = ${response.body}");

    get = false;
    setState(() {});
    if (response.statusCode == 200) {
      quotes = jsonDecode(response.body);
      debugPrint("=====$quotes====");
      data = jsonDecode(quotes['extra']);
      debugPrint("==666666===${data['_data']}====");
      List random = data['_data']..shuffle();    //for random
      print("@@@@@@@@@@@  $random");
      print("Update ======${quotes["maintenance_mode"].runtimeType}");
      if (quotes["force_update"] == "1") {
        print("Update ======${quotes["force_update"]}");
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;
        print("Version ======$version");
        print("Version ======${quotes['app_version']}");

        if (version != quotes['app_version']) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Update"),
                content: Text("Update Available"),
                actions: [
                  TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse("${quotes['update_url']}"),
                            mode: LaunchMode.externalApplication);
                      },
                      child: Text("Update")),
                ],
              );
            },
          );
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Quotes(prefs: prefs, data: data, quotes: quotes),
              ),(route) => false);
          flutterToast("Get data Successfully!");
        }
      } else if (quotes['skip_update'] == "1") {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String version = packageInfo.version;
        // print("+++++++++++++++++$version");
        if (version != quotes['app_version']) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Update"),
                content: Text("Update Available"),
                actions: [
                  TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse("${quotes['update_url']}"),
                            mode: LaunchMode.externalApplication);
                      },
                      child: Text("Update")),
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Quotes(
                                  prefs: prefs, quotes: quotes, data: data),
                            ),(route) => false,);
                        flutterToast("Get data Successfully!");
                      },
                      child: Text("Skip")),
                ],
              );
            },
          );
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    Quotes(prefs: prefs, quotes: quotes, data: data),
              ),(route) => false,);
          flutterToast("Get data Successfully!");
        }
      } else if (quotes["maintenance_mode"] == "1") {
        showDialog(barrierDismissible: false,
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(quotes['maintenance_title']),
              content: Text(quotes['maintenance_description']),
            );
          },
        );
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Quotes(prefs: prefs, quotes: quotes, data: data),), (route) => false);
        flutterToast("Get data successfully!");
      }
    } else {
      flutterToast("Failed");
    }
  }
}
