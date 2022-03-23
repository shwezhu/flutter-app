import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../http_utils.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}): super(key: key);

  @override
  State createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State {
  late Widget temperatureChart = const Text("请尝试下拉刷新, 暂无数据");
  Future<List<FlSpot>?> generateTempSpot() async{
    final data = await getTemperature('select * from temperature limit 0,48');
    if(data == null) {
      return null;
    }

    final List<FlSpot> spots = data
        .map((temperature) => FlSpot(temperature.date.hour + temperature.date.minute/100, temperature.value))
        .toList();

    return spots;
  }

  Future<Widget?> generateTempChart() async{
    var tempSpots = await generateTempSpot();
    if(tempSpots == null) {
      return null;
    }

    return Container(
      padding: const EdgeInsets.all(0),
      width: double.infinity,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          lineBarsData: [
            // The red line
            LineChartBarData(
              spots: tempSpots,
              isCurved: true,
              barWidth: 3,
            ),
          ],
        ),
      ),
    );
  }

  Future _refresh() async {
    var tem = await generateTempChart() ?? temperatureChart;

    // if no setState, RefreshIndicator below won't work
    setState(() {
      temperatureChart = tem;
    });

    return Future.delayed(const Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('温室大棚环境信息'),
        leading: const Icon(Icons.wb_sunny_outlined),
      ),
      // By design, RefreshIndicator only works with ListView.
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
            padding: const EdgeInsets.only(top: 45, bottom: 10),
            children: [
              // if don't use SizedBox: RenderLineChart object was given an infinite size during layout.
              // https://stackoverflow.com/questions/60058946/flutter-object-was-given-an-infinite-size-during-layout
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.5,
                child: temperatureChart,
              ),
            ]
        ),
      ),
    );
  }
}