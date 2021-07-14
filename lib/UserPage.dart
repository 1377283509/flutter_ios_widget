import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserPage extends StatefulWidget {
  final String userid;
  final String author;

  const UserPage({Key key, @required this.userid, @required this.author})
      : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TextEditingController idController;
  TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.userid);
    nameController = TextEditingController(text: widget.author);
  }

  @override
  void dispose() {
    super.dispose();

    idController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户中心"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            TextField(
                controller: idController,
                decoration:
                InputDecoration(helperText: "点击可编辑ID", labelText: "ID")),
            TextField(
                controller: nameController,
                decoration: InputDecoration(
                    helperText: "点击可编辑NAME", labelText: "NAME")),
            const SizedBox(
              height: 52,
            ),
            ElevatedButton(onPressed: () async{
              // TODO: 更新Widget信息
              MethodChannel channel = MethodChannel("com.cc.ToDo.widgets");
              var res = await channel.invokeMethod("updateWidgetData", {
                "userid":idController.text,
                "author":nameController.text
              });

              print(res);
              print(res.runtimeType);

            }, child: Text("保存"))
          ],
        ),
      ),
    );
  }
}
