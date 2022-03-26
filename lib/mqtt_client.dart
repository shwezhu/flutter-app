import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


class MyMqttClient {
  MqttServerClient client;

  MyMqttClient(this.client) {
    // Set the protocol to V3.1.1 for iot-core,
    // if you fail to do this you will receive a connect ack with the response code
    // 0x01 Connection Refused, unacceptable protocol version
    client.setProtocolV311();
    // logging if you wish
    client.logging(on: false);
    // If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
    client.keepAlivePeriod = 20;
  }

  Future<void> mqttInit(String topic, Function(List<MqttReceivedMessage> event) callBack) async{
    // Set the protocol to V3.1.1 for iot-core,
    // if you fail to do this you will receive a connect ack with the response code
    // 0x01 Connection Refused, unacceptable protocol version
    client.setProtocolV311();
    // logging if you wish
    client.logging(on: false);
    // If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
    client.keepAlivePeriod = 20;

    ///!!! try... NoConnectionException, SocketException
    await client.connect();

    client.subscribe(topic, MqttQos.atMostOnce);
    // Listen topic, set callback
    client.updates!.listen(callBack);
  }

  void _onMessage(List<MqttReceivedMessage> event) {
    final recMess = event[0].payload as MqttPublishMessage;
    final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
    Uint8List decodedBytes;
    ///!!!try... on FormatException catch (e)
    decodedBytes = base64Decode(message);
    final fileImg = File('testImage.jpg');
    fileImg.writeAsBytesSync(decodedBytes, mode: FileMode.write);
  }
}