import 'package:flutter/material.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'models/storemodel.dart';
import 'store.dart';


class ShowStore extends StatefulWidget {
  final int store_id;

  const ShowStore({Key? key, required this.store_id}) : super(key: key);

  @override
  _ShowStore createState() => _ShowStore();
}

class _ShowStore extends State<ShowStore> {
  StoreModel? _store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(),
      //drawer: CustomDrawer(),
      body: StoreBody(
        store_id: widget.store_id, // ✅ تمرير store_id هون
        onStoreLoaded: (store) {
          setState(() {
            _store = store;
          });
        },
      ),
    );
  }
}