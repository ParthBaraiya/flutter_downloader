import 'package:downloader/views/icons.dart';
import 'package:downloader/views/scaffold_title.dart';
import 'package:flutter/material.dart';

class DownloaderScaffolds extends StatelessWidget {
  const DownloaderScaffolds({
    super.key,
    required this.sliver,
    required this.onBack,
    required this.title,
  });

  final Widget sliver;
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leading: DownloaderIconButton.medium(
              onTap: onBack,
              icon: Icons.arrow_back,
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              collapseMode: CollapseMode.parallax,
              expandedTitleScale: 1.2,
              titlePadding: EdgeInsets.fromLTRB(70, 0, 0, 10),
              title: ScaffoldTitle.small(
                title: title,
              ),
            ),
          ),
          sliver,
        ],
      ),
    );
  }
}
