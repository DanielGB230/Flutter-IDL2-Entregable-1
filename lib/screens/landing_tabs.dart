import 'package:flutter/material.dart';

class LandingTabs extends StatefulWidget {
  const LandingTabs({super.key});

  @override
  State<LandingTabs> createState() => _LandingTabsState();
}

class _LandingTabsState extends State<LandingTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<TextData> _data = [
    TextData(
        title: "Title 1",
        body:
            "Lorem ipsum dolom asd asd sad jsalkdjsakld jskal djlskadjsalkdjsdlk d slakjskladj sakldj sak"),
    TextData(
        title: "Title 2",
        body:
            "Lorem ipsum dolom asd asd sad jsalkdjsakld jskal djlskadjsalkdjsdlk d slakjskladj sakldj sak"),
    TextData(
        title: "Title 3",
        body:
            "Lorem ipsum dolom asd asd sad jsalkdjsakld jskal djlskadjsalkdjsdlk d slakjskladj sakldj sak"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: 150,
            child: TabBarView(
              controller: _tabController,
              children: _data.map<Widget>((e) => TabBody(data: e)).toList(),
            ),
          ),
          SizedBox(height: 50),
          Container(
            // color: Colors.red,
            //width: 100,
        
          ),
        ],
      ),
    );
  }
}
