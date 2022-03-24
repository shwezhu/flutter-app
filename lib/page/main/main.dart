import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../http_utils.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}): super(key: key);

  @override
  State createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State {
  late Widget _temChart = const Text("请尝试下拉刷新, 暂无数据");
  List<FlSpot> _temSpots = const [];
  double _temMinX = 0;
  double _temMaxX = 0;
  double _temMinY = 30;
  double _temMaxY = 0;
  double _temLeftTitlesInterval = 0;
  double _temBottomTitlesInterval = 0;
  double _currentTemperature = 0;

  late Widget _humChart = const Text("请尝试下拉刷新, 暂无数据");
  List<FlSpot> _humSpots = const [];
  double _humMinX = 0;
  double _humMaxX = 0;
  double _humMinY = 30;
  double _humMaxY = 0;
  double _humLeftTitlesInterval = 0;
  double _humBottomTitlesInterval = 0;
  double _currentHumidity = 0;

  SideTitles _temBottomTitles() {
    return SideTitles(
      showTitles: true,
      margin: 5,
      interval: _temBottomTitlesInterval,
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff67727d),
        fontWeight: FontWeight.bold,
        fontSize: 8,
      ),
      getTitles: (value) {
        if(value == _temMaxX) {
          return '';
        }
        final dateFormat = DateFormat('HH:mm');
        return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
      },
    );
  }

  SideTitles _temLeftTitles() {
    return SideTitles(
      showTitles: true,
      margin: 6,
      interval: _temLeftTitlesInterval,
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff67727d),
        fontWeight: FontWeight.bold,
        fontSize: 7,
      ),
      getTitles: (value) {
        if(value == _temMinY || value == _temMaxY) {
          return '';
        }
        return value.toInt().toString() + '°C';
      },
    );
  }

  LineChartData _temGenerateChartData() {
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
        bottomTitles: _temBottomTitles(),
        leftTitles: _temLeftTitles(),
      ),
      minX: _temMinX,
      maxX: _temMaxX,
      minY: _temMinY,
      maxY: _temMaxY,
      lineBarsData: [
        LineChartBarData(
          spots: _temSpots,
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

  Future<int> _temRefreshData() async{
    final data = await getTemperature();
    if(data == null) {
      return -1;
    }

    _temSpots = data
        .map((elementOfData) => FlSpot(elementOfData.date.millisecondsSinceEpoch.toDouble(), elementOfData.value))
        .toList();

    _temMinX = _temSpots.first.x;
    _temMaxX = _temSpots.last.x;
    _temBottomTitlesInterval = (_temMaxX - _temMinX)/8;
    data.map((elementOfData) => {
      _temMinY = _temMinY > elementOfData.value ? elementOfData.value : _temMinY,
      _temMaxY = _temMaxY < elementOfData.value ? elementOfData.value : _temMaxY
    }).toList();

    _temMinY = _temMinY.floorToDouble();
    _temMaxY = _temMaxY.ceilToDouble();
    _temLeftTitlesInterval = (_temMaxY - _temMinY)/6;

    _currentTemperature = data.last.value;

    return 0;
  }

  Future<Widget?> _temRefreshChart() async{
    final res = await _temRefreshData();
    if(res == -1) {
      return null;
    }

    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 10, left: 5, right: 16),
      width: double.infinity,
      child: LineChart(
        _temGenerateChartData(),
      ),
    );
  }

  Future _temOnRefresh() async {
    var tem = await _temRefreshChart() ?? _temChart;

    // if no setState, RefreshIndicator below won't work
    setState(() {
      _temChart = tem;
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
        onRefresh: _temOnRefresh,
        child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              Container(
                padding: const EdgeInsets.only(left: 6, top: 8),
                child: Text("当前温度: $_currentTemperature ℃"),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.5,
                child: _temChart,
              ),
            ]
        ),
      ),
    );
  }
}