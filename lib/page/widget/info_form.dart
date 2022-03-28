import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/widget/input_widget.dart';
import 'package:my_flutter_app/data/visitor.dart';
import 'package:my_flutter_app/http_utils.dart';
import 'package:my_flutter_app/config.dart';

class InfoForm extends StatefulWidget {
  const InfoForm({Key? key}) : super(key: key);

  @override
  InfoFormState createState() {
    return InfoFormState();
  }
}

class InfoFormState extends State<InfoForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameField = TextEditingController();
  TextEditingController phoneField = TextEditingController();
  TextEditingController idField = TextEditingController();
  TextEditingController cityField = TextEditingController();

  Future warningDialog(String title, String content) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  bool _isPhoneNumber(String? value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{11}$)';
    RegExp regExp = RegExp(pattern);
    if(value == null) {
      return false;
    }
    else if (!regExp.hasMatch(value)) {
      return false;
    }
    else {
      return true;
    }
  }

  bool _isNumeric(String? value) {
    if(value == null || value.isEmpty) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 20, bottom: 25),
              child: InputWidget(
                controller: nameField,
                label: "姓名",
                validator: (value){
                  if(_isNumeric(value)) {
                    return "请输入有效的名字";
                  }
                  else {
                    return null;
                  }
                },
              ),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 25),
              child: InputWidget(
                  controller: phoneField,
                  label: "手机",
                  validator: (value){
                    if(!_isPhoneNumber(value)) {
                      return "请输入有效的手机号";
                    }
                    else {
                      return null;
                    }
                  },
              ),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 25),
              child: InputWidget(
                  controller: cityField,
                  label: "最近15天停留的城市"
              ),
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 25),
              child: InputWidget(
                  controller: idField,
                  label: "身份ID"
              ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: ElevatedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  final visitor = Visitor(nameField.text, phoneField.text, idField.text, cityField.text);
                  bool isSuccessful = await addVisitor(Config.visitorsTable, visitor.toJson());
                  if(isSuccessful) {
                    await warningDialog("提示", "添加成功!");
                    nameField.clear();
                    phoneField.clear();
                    cityField.clear();
                    idField.clear();
                  }
                  else {
                    await warningDialog("警告", "添加失败, 请重新提交!");
                  }
                }
              },
              child: const Text('提交'),
            ),
          ),
        ],
      ),
    );
  }
}