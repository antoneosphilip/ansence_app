import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core_widget/custom_app_bar/custom_App_bar.dart';
import '../screen_widget/search_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      appBar: CustomAppBar(title: 'Search',),
      body: SingleChildScrollView(
        child: SearchScreenWidget(),
      ),
    );
  }
}
