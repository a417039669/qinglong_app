import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qinglong_app/base/ql_app_bar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/utils/update_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

/// @author NewTab

class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _AboutPageState();
}

class _AboutPageState extends ConsumerState<AboutPage> {
  String desc = "";

  @override
  void initState() {
    super.initState();
    getInfo();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      update();
    });
  }

  void update() async {
    String? result = await UpdateUtils().checkUpdate(true);
    if (result != null && result.isNotEmpty) {
      UpdateDialog updateDialog = UpdateDialog(context, title: "发现新版本", updateContent: "版本号:v${result}", onUpdate: () {
        UpdateUtils.launchURL(result);
      });
      updateDialog.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QlAppBar(
        canBack: true,
        title: "关于",
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Image.asset(
              "assets/images/ql.png",
              height: 50,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "青龙",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: ref.watch(themeProvider).themeColor.titleColor(),
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Version ${desc}",
              style: TextStyle(
                color: ref.watch(themeProvider).themeColor.descColor(),
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                _launchURL("https://t.me/qinglongapp");
              },
              child: Text(
                "Telegram频道",
                style: TextStyle(
                  color: ref.watch(themeProvider).primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    _launchURL("https://github.com/qinglong-app/qinglong_app/releases");
                  },
                  child: Text(
                    "版本更新",
                    style: TextStyle(
                      color: ref.watch(themeProvider).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    _launchURL("https://github.com/qinglong-app/qinglong_app");
                  },
                  child: Text(
                    "项目地址",
                    style: TextStyle(
                      color: ref.watch(themeProvider).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String _url) async {
    try {
      await launch(_url);
    } catch (e) {
      logger.e(e);
    }
  }

  void getInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;

    desc = version;
    setState(() {});
  }
}
