import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:couchify/couchify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await CouchbaseLite.init();
    print(await Query.getValue());

    DatabaseConfiguration configuration = DatabaseConfiguration();
    Database db = Database("flutterDb", configuration);
    print(await db.getPath());

    MutableDocument doc = MutableDocument.id("doc1").setValue("hello", 3);
    await db.save(doc);

    Document d2 = await db.get("doc1");
    print("here");
    print(d2.toMap());
    print(d2.getId());

    var mut = d2.toMutable().setValue("jkj", 798);
    await db.save(mut);

    d2 = await db.get("doc1");
    print(d2.toMap());

    // var doc2 = MutableDocument().setValue("bye", "rgrg");
    // await db.save(doc2);

    // await db.close();

    Query q = QueryBuilder.select(
            [SelectResult.expression(Meta.id), SelectResult.all()])
        .from(DataSource.database(db));

    ResultSet rs = await q.execute();
    await for (Result result in rs.getStream()) {
      print(result.toMap());
    }

    var rs2 = await q.execute();

    await rs2.getStream().forEach((element) {
      print(element.toMap());
    });

    var rs3 = await q.execute();

    var res = await rs3.next();

    while (res != null) {
      print(res.toMap());
      res = await rs3.next();
    }

    await rs3.getStream().forEach((element) {
      print(element.toMap());
    });

    print(await rs3.allResults());

    var rs4 = await q.execute();

    for (var ress in await rs4.allResults()) {
      print(ress.toMap());
    }

    print("done");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
