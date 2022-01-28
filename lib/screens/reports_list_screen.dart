import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reports.dart';
import '../widgets/report_item.dart';

class ReportsOverviewScreen extends StatefulWidget {
  static const routeName = '/reports-overview';

  @override
  State<ReportsOverviewScreen> createState() => _ReportsOverviewScreenState();
}

class _ReportsOverviewScreenState extends State<ReportsOverviewScreen> {
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    //isLoading = false;
  }

  Future<void> _getMoreData() async {
    await Provider.of<Reports>(context, listen: false).fetchMoreReports();

    // setState(() {});
  }

  Future<void> _refreshReports(context) async {
    await Provider.of<Reports>(context, listen: false).fetchAndSetAllReports();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _refreshReports(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    child: Consumer<Reports>(
                      builder: (context, reportsData, child) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemExtent: 80,
                          itemBuilder: (ctx, i) => reportsData.items.length == i
                              ? Center(child: CircularProgressIndicator())
                              : Column(children: [
                                  ChangeNotifierProvider.value(
                                      value: reportsData.items[i],
                                      child: ReportItem()),
                                  Divider()
                                ]),
                          itemCount: reportsData.items.length + 1,
                        ),
                      ),
                    ),
                    onRefresh: () => _refreshReports(context)));
  }
}
