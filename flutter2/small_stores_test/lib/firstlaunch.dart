import 'package:flutter/material.dart';
import 'package:small_stores_test/login.dart';

import 'style.dart';
import 'variables.dart';

class FirstLaunch extends StatefulWidget {
  @override
  _FirstLaunch createState() => _FirstLaunch();
}

class _FirstLaunch extends State<FirstLaunch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        /*appBar: AppBar(
          title: Text(app_name,style: style_name_app_o,),
          centerTitle: true,
        ),*/
        body: SingleChildScrollView(
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(24.0),

                    child: Column(
                        children: [
                          SizedBox(height: 32,),
                          image_login,
                          SizedBox(height: 16,),
                          Text(app_name,style: style_name_app_o,),
                          SizedBox(height: 16,),
                          Text(a_FirstLaunch_s,style: style_text_normal,),
                          SizedBox(height: 16,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Login()),
                                );
                              },
                              style: style_button,
                              child: Text(a_start_b),
                            ),
                          )
                        ]
                    )
                )
            )
        )
    );
  }
}