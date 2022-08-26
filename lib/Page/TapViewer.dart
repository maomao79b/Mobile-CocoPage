import 'package:flutter/material.dart';
import '../coco_page.dart';
import 'Map.dart';

class TapScreen extends StatefulWidget {
  const TapScreen({Key? key}) : super(key: key);

  @override
  State<TapScreen> createState() => _TapScreenState();
}

class _TapScreenState extends State<TapScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).padding.top;
    kToolbarHeight;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.green,
            flexibleSpace: Container(
              decoration: const BoxDecoration(),
            ),
            title: const  Text(
                "Cocoworks",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(text: "สวนของฉัน",),
                Tab(text: "แผนที่สวนมะพร้าว",)
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Cocopage(),
              GetPoints()
            ],
          ),
        )
    );
  }
}

