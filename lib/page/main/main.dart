import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_app/http_utils.dart';

class Wrapper {
  Widget chart = const Text("请尝试下拉刷新, 暂无数据");
  List<FlSpot> spots = [];
  double minX = 0;
  double maxX = 0;
  double minY = 100;
  double maxY = 0;
  double leftTitlesInterval = 0;
  double bottomTitlesInterval = 0;
  double currentValue = 0;
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}): super(key: key);

  @override
  State createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State {
  final Wrapper _temChartParameter = Wrapper();
  final Wrapper _humChartParameter = Wrapper();

  SideTitles _getBottomTitles(Wrapper wrapper) {
    return SideTitles(
      showTitles: true,
      margin: 5,
      interval: wrapper.bottomTitlesInterval,
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff67727d),
        fontWeight: FontWeight.bold,
        fontSize: 8,
      ),
      getTitles: (value) {
        if(value == wrapper.maxX) {
          return '';
        }
        final dateFormat = DateFormat('HH:mm');
        return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
      },
    );
  }

  SideTitles _getLeftTitles(Wrapper wrapper) {
    return SideTitles(
      showTitles: true,
      margin: 6,
      interval: wrapper.leftTitlesInterval,
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff67727d),
        fontWeight: FontWeight.bold,
        fontSize: 7,
      ),
      getTitles: (value) {
        if(value == wrapper.minY || value == wrapper.maxY) {
          return '';
        }
        return value.toInt().toString() + '°C';
      },
    );
  }

  LineChartData _generateChartData(Wrapper wrapper) {
    return LineChartData(
      // appearance of X, Y axis
      borderData: FlBorderData(
        show: true,
        border: const Border(
          left: BorderSide(color: Color(0xff4e4965), width: 1),
          top: BorderSide(color: Colors.transparent),
          bottom: BorderSide(color: Color(0xff4e4965), width: 1),
          right: BorderSide(color: Colors.transparent),
        ),
      ),
      // background line
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        show: true,
        // titles of left, top, right and bottom axis
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: _getBottomTitles(wrapper),
        leftTitles: _getLeftTitles(wrapper),
      ),
      minX: wrapper.minX,
      maxX: wrapper.maxX,
      minY: wrapper.minY,
      maxY: wrapper.maxY,
      lineBarsData: [
        LineChartBarData(
          spots: wrapper.spots,
          isCurved: true,
          barWidth: 3,

          // show dot of the spot
          dotData: FlDotData(
            show: false,
          ),

          // show shadow below line
          belowBarData: BarAreaData(
            show: true,
            colors: const [Color(0x33aa4cfc)],
          ),
        ),
      ],
    );
  }

  Future<int> _refreshData(Wrapper wrapper, Function() getData) async{
    final data = await getData();
    if(data == null) {
      return -1;
    }
    // you have to do this, make spots = []
    wrapper.spots = [];
    data.map((e) {wrapper.spots.add(FlSpot(e.date.millisecondsSinceEpoch.toDouble(), e.value));}).toList();

    wrapper.minX = wrapper.spots.first.x;
    wrapper.maxX = wrapper.spots.last.x;
    wrapper.bottomTitlesInterval = (wrapper.maxX - wrapper.minX)/8;
    wrapper.spots.map((elementOfData) => {
      wrapper.minY = wrapper.minY > elementOfData.y ? elementOfData.y : wrapper.minY,
      wrapper.maxY = wrapper.maxY < elementOfData.y ? elementOfData.y : wrapper.maxY,
    }).toList();

    wrapper.minY = wrapper.minY.floorToDouble();
    wrapper.maxY = wrapper.maxY.ceilToDouble();
    wrapper.leftTitlesInterval = (wrapper.maxY - wrapper.minY)/6;

    wrapper.currentValue = wrapper.spots.last.y;

    return 0;
  }

  Future<Widget?> _refreshChart(Wrapper wrapper, Function() getData) async{
    var res = await _refreshData(wrapper, getData);

    if(res == -1) {
      return null;
    }

    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 10, left: 5, right: 16),
      width: double.infinity,
      child: LineChart(
        _generateChartData(wrapper),
      ),
    );
  }

  Future _onRefresh() async {
    final tem = await _refreshChart(_temChartParameter, getTemperature) ?? _temChartParameter.chart;
    final hum = await _refreshChart(_humChartParameter, getHumidity) ?? _humChartParameter.chart;

    // If no setState, RefreshIndicator won't work.
    setState(() {
      _temChartParameter.chart = tem;
      _humChartParameter.chart = hum;
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
      /// Core code blew, two line char: _temChart and _humChart
      // Must use SizedBox to wrap these two line chart _temChart and _humChart.
      // if don't use SizedBox: RenderLineChart object was given an infinite size during layout.
      // https://stackoverflow.com/questions/60058946/flutter-object-was-given-an-infinite-size-during-layout
      // By design, RefreshIndicator only works with ListView.
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              Container(
                padding: const EdgeInsets.only(left: 6, top: 8),
                child: Text("当前温度: ${_temChartParameter.currentValue} ℃"),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: _temChartParameter.chart,
              ),
              Container(
                padding: const EdgeInsets.only(left: 6, top: 8),
                child: Text("当前湿度: ${_humChartParameter.currentValue} H"),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: _humChartParameter.chart,
              ),
            ]
        ),
      ),
    );
  }
}