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
    runCouchifyExample();
  }

  Future runCouchifyExample() async {
    // initialize Couchbase Lite
    await CouchbaseLite.init();

    // create a database configuration
    // default directory for the database is the application files directory
    // you can also specify a custom directory using the setDirectory method
    DatabaseConfiguration configuration = DatabaseConfiguration();

    // create a new database (or open an existing one) with name testDb
    Database db = Database("testDb", configuration);

    // print the location of the database in the device
    // following statement will print /data/data/<package-name>/files/testDb.cblite2/
    print(await db.getPath());

    // create a new mutable document with a specified id and set a key-value pair
    MutableDocument doc = MutableDocument.id("doc1").setValue("key1", "value1");

    // save the document in the database
    await db.save(doc);

    // fetch the document using its id
    Document fetchedDoc = await db.get("doc1");

    // convert it to a mutable document and modify the document
    MutableDocument updatedDoc = fetchedDoc.toMutable();
    updatedDoc.setValue("key1", "new-value");
    updatedDoc.setValue("key2", 1234);

    // save it to the database to update the existing document
    await db.save(updatedDoc);

    // build a query using the QueryBuilder API (similar to the official Couchbase Lite Android API)
    Query query = QueryBuilder.select(
            [SelectResult.expression(Meta.id), SelectResult.all()])
        .from(DataSource.database(db));

    // execute the query to get a ResultSet
    ResultSet rs = await query.execute();

    // iterate over the result set and print contents of each result as a Map
    await for (Result result in rs.getStream()) {
      print(result.toMap());
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   await CouchbaseLite.init();
  //   // print(await Query.getValue());
  //
  //   DatabaseConfiguration configuration = DatabaseConfiguration();
  //   Database db = Database("flutterDb", configuration);
  //   print(await db.getPath());
  //
  //   MutableDocument doc = MutableDocument.id("doc1").setValue("hello", 3);
  //   await db.save(doc);
  //
  //   Document d2 = await db.get("doc1");
  //   print("here");
  //   print(d2.toMap());
  //   print(d2.getId());
  //
  //   var mut = d2.toMutable().setValue("jkj", 798);
  //   await db.save(mut);
  //
  //   d2 = await db.get("doc1");
  //   print(d2.toMap());
  //
  //   // var doc2 = MutableDocument().setValue("bye", "rgrg");
  //   // await db.save(doc2);
  //
  //   // await db.close();
  //
  //   Query q = QueryBuilder.select(
  //           [SelectResult.expression(Meta.id), SelectResult.all()])
  //       .from(DataSource.database(db));
  //
  //   ResultSet rs = await q.execute();
  //   await for (Result result in rs.getStream()) {
  //     print(result.toMap());
  //   }
  //
  //   var rs2 = await q.execute();
  //
  //   await rs2.getStream().forEach((element) {
  //     print(element.toMap());
  //   });
  //
  //   var rs3 = await q.execute();
  //
  //   var res = await rs3.next();
  //
  //   while (res != null) {
  //     print(res.toMap());
  //     res = await rs3.next();
  //   }
  //
  //   await rs3.getStream().forEach((element) {
  //     print(element.toMap());
  //   });
  //
  //   print(await rs3.allResults());
  //
  //   var rs4 = await q.execute();
  //
  //   for (var ress in await rs4.allResults()) {
  //     print(ress.toMap());
  //   }
  //
  //   print("done");
  // }

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
