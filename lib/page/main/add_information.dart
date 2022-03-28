import 'package:flutter/material.dart';
import 'package:my_flutter_app/page/widget/info_form.dart';

class AddInformationPage extends StatelessWidget {
  const AddInformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      child: Scaffold(
        appBar: AppBar(title: const Text('信息填写')),
        body: const SingleChildScrollView(
          child: InfoForm(),
        ),
      ),
    );
  }
}
