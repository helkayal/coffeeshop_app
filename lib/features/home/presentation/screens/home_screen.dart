import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widgets/app_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'app_name'.tr()),
      body: Center(child: Text('home'.tr())),
    );
  }
}
