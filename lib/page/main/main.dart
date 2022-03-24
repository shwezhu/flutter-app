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
  late Widget temperatureChart = const Text("请尝试下拉刷新, 暂无数据");
  List<FlSpot> tempSpots = const [];
  double _minX = 0;
  double _maxX = 0;
  double _minY = 30;
  double _maxY = 0;
  double _leftTitlesInterval = 0;
  double _bottomTitlesInterval = 0;
  double _currentTemperature = 0;

  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
      margin: 5,
      interval: _bottomTitlesInterval,
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff67727d),
        fontWeight: FontWeight.bold,
        fontSize: 8,
      ),
      getTitles: (value) {
        if(value == _maxX) {
          return '';
        }
        final dateFormat = DateFormat('HH:mm');
        return dateFormat.format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
      },
    );
  }

  SideTitles _leftTitles() {
    return SideTitles(
      showTitles: true,
      margin: 6,
      interval: _leftTitlesInterval,
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff67727d),
        fontWeight: FontWeight.bold,
        fontSize: 7,
      ),
      getTitles: (value) {
        if(value == _minY || value == _maxY) {
          return '';
        }
        return value.toInt().toString() + '°C';
      },
    );
  }

  Future<int> _generateTempSpot() async{
    final data = await getTemperature('select * from (select * from temperature order by id desc limit 20) aa order BY id');
    if(data == null) {
      return -1;
    }

    tempSpots = data
        .map((temperature) => FlSpot(temperature.date.millisecondsSinceEpoch.toDouble(), temperature.value))
        .toList();

    _minX = tempSpots.first.x;
    _maxX = tempSpots.last.x;
    _bottomTitlesInterval = (_maxX - _minX)/8;
    data.map((element) => {
      _minY = _minY > element.value ? element.value : _minY,
      _maxY = _maxY < element.value ? element.value : _maxY
    }).toList();

    _minY = _minY.floorToDouble();
    _maxY = _maxY.ceilToDouble();
    _leftTitlesInterval = ((_maxY - _minY)/6);

    _currentTemperature = data.last.value;

    return 0;
  }


  LineChartData mainData() {
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
      gridData: FlGridData(
        show: true,
      ),
      titlesData: FlTitlesData(
        show: true,
        // left top right and bottom axis
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: _bottomTitles(),
        leftTitles: _leftTitles(),
      ),
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
      lineBarsData: [
        LineChartBarData(
          spots: tempSpots,
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

  Future<Widget?> _generateTempChart() async{
    final res = await _generateTempSpot();
    if(res == -1) {
      return null;
    }

    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 10, left: 5, right: 16),
      width: double.infinity,
      child: LineChart(
        mainData(),
      ),
    );
  }

  Future _refresh() async {
    var tem = await _generateTempChart() ?? temperatureChart;

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
            padding: const EdgeInsets.all(0),
            children: [
              Container(
                padding: const EdgeInsets.only(left: 6, top: 8),
                child: Text("当前温度: $_currentTemperature ℃"),
              ),
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