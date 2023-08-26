


import 'dart:io';

import 'package:aiodownloader/widgets/reusable_tile.dart';
import 'package:flutter/material.dart';

import '../app theme/app_theme.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {





  @override
  Widget build(BuildContext context) {

    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Drawer(
      backgroundColor: AppTheme.mainThemeColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Image.asset('assets/images/app_icon.png',
              height: 100,
              width: 100,
            ),
            Text("AIO Downloader",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
            const SizedBox(height: 5),
            const Divider(color: Colors.blueGrey),
            const SizedBox(height: 20),
            ReusableTile(
              icon: Icons.calendar_month,
              title: "Screen 1",
              onTap: () {
                // Get.to(()=>MessagesAndComment());
                // navigateToPage(context, const AppointmentsScreen());
              },
            ),
            ReusableTile(
              icon: Icons.calendar_month,
              title: "Screen 2",
              onTap: () {
                // Get.to(()=>Post());
                // navigateToPage(context, const AppointmentsScreen());
              },
            ),
            ReusableTile(
              icon: Icons.settings,
              title: "Settings",
              onTap: () {},
            ),
            ReusableTile(
              icon: Icons.person,
              title: "My Profile",
              onTap: () {},
            ),
            const Spacer(),

          ],
        ),
      ),
    );
  }
}