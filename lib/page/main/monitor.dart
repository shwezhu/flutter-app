import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';


class MyImage {
  Uint8List bytes;
  String info;

  MyImage(this.bytes, this.info);
}

class MonitorPage extends StatefulWidget {
  const MonitorPage({Key? key}): super(key: key);

  @override
  State createState() {
    return _MonitorPageState();
  }
}

class _MonitorPageState extends State {
  String topic = 'greenhouse/alarm';
  final client = MqttBrowserClient('localhost', 'my_flutter_app_1');
  List<MyImage> images = [];
  var imageWidgets = <Widget>[
    const Text("暂无不明入侵者"),
  ];

  /// initState() is a method which is called once when the stateful widget is inserted in the widget tree.
  @override
  initState() {
    super.initState();
    // Set the protocol to V3.1.1 for iot-core,
    // if you fail to do this you will receive a connect ack with the response code
    // 0x01 Connection Refused, unacceptable protocol version
    client.setProtocolV311();
    // logging if you wish
    client.logging(on: false);
    // If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
    client.keepAlivePeriod = 20;
  }

  void _connectMqtt() async{
    // Connect the client, any errors here are communicated by raising of the appropriate exception.
    try {
      await client.connect();
    } on NoConnectionException catch(e){
      client.disconnect();
      showAlertDialog(context, '警告', e.toString());
      return;
    } on SocketException catch(e){
      // Raised by the socket layer
      client.disconnect();
      showAlertDialog(context, '警告', e.toString());
      return;
    }
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      showAlertDialog(context, '通知', '连接成功');
    }

    client.subscribe(topic, MqttQos.atMostOnce);
    // Listen topic, set callback
    client.updates!.listen(_onMessage);
  }

  // a callback function for mqtt message
  void _onMessage(List<MqttReceivedMessage> event) {
    final recMess = event[0].payload as MqttPublishMessage;
    final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    Uint8List decodedBytes;
    ///!!!try... on FormatException catch (e)
    decodedBytes = base64Decode(message);
    // add an image bytes information to list
    images.add(MyImage(decodedBytes, getCurrentTime()));
    _updateImageWidgets();
    /// So if the state of the widget changes you have to call setState to trigger a rebuild of the view and
    /// see immediately the changes implied by the new state.
    setState(() {});
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _updateImageWidgets() {
    imageWidgets = <Widget>[];
    images.map((image) {
      imageWidgets.add(
          Column(
            children: [
              Text(image.info),
              Image.memory(image.bytes),
            ],
          )
      );
    }).toList();
  }

  String getCurrentTime() {
    DateTime now = DateTime.now();
    return now.hour.toString() + ':' + now.minute.toString() + ' '
        + now.day.toString() + '/' + now.month.toString() + '/'
        + now.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('监控图像'),
        leading: const Icon(Icons.monitor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: imageWidgets,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _connectMqtt,
        child: const Icon(Icons.connect_without_contact),
      ),
     floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat
    );
  }
}