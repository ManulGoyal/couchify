# couchify

Couchify is a Couchbase Lite API for Flutter developers. The objective is to keep the Flutter API as
close as possible to the official Android (Java) API provided by Couchbase Lite, so that anyone familiar
with that API can easily use the Flutter API. The plugin uses Couchbase Lite Android EE 2.8.5.
Currently the plugin only supports Android and is not available for iOS.

## Getting Started

1. Depend on it:
```
dependencies:
  couchify: ^0.1.0
```

2. Set the `minSdkVersion` to 19 in the app-level `build.gradle` file (`android/app/build.gradle`):
```
android {
    ...
    
    defaultConfig {
        ...
        minSdkVersion 19
        ...
    }
    
    ...
}
```

3. Add the `xmlns:tools` namespace to the `manifest` element in the `AndroidManifest.xml`
   file (generally found at `android/src/main/AndroidManifest.xml`). Also add the `tools:replace`
   attribute to the `application` element directly below the `manifest` element, as shown below:
```
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"      <----
    package=...>
    <application
        android:label=...
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        tools:replace="android:label">                  <----
```

4. Import the module in the desired dart file and you are ready to go:
```
import 'package:couchify/couchify.dart';
```

## Example Usage

```
// initialize Couchbase Lite
await CouchbaseLite.init();

// create a database configuration
// default directory for the database is the application files directory
// you can also specify a custom directory using the setDirectory method
DatabaseConfiguration configuration = DatabaseConfiguration();

// create a new database (or open an existing one) with name testDb
Database db = await Database.open("testDb", configuration);

// print the location of the database in the device
// following statement will print /data/data/<package-name>/files/testDb.cblite2/
print(await db.getPath());

// create a new mutable document with a specified id and set a key-value pair
MutableDocument doc =
    MutableDocument.id("doc1").setString("key1", "value1");

// create a mutable array and add two values to it, then add it to the document
MutableArray array = MutableArray().addString("value1").addInt(1234);
doc.setArray("an array", array);

// create a mutable dictionary and add two keys to it, then add it to the document
MutableDictionary dictionary = MutableDictionary()
    .setString("key1", "value1")
    .setBoolean("key2", false);
doc.setDictionary("a dictionary", dictionary);

// save the document in the database
await db.save(doc);

// fetch the document using its id
Document? fetchedDoc = await db.getDocument("doc1");

if (fetchedDoc != null) {
  // convert it to a mutable document and modify the document
  MutableDocument updatedDoc = fetchedDoc.toMutable();
  updatedDoc.setString("key1", "new-value");
  updatedDoc.setDate("current_date", DateTime.now());
  updatedDoc.setValue("a null value", null);

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
```

## Supported Features

This plugin is under development. Currently, the following features are supported:

1. Opening a new or existing database locally and specifying custom directory for the database
2. CRUD operations on the documents:
   * Creating, updating and saving mutable documents
   * Fetching documents by id
   * Deleting documents
3. Deleting a database
4. Having multiple different databases open at the same time (by creating multiple Database objects)
5. Array and Dictionary types along with their mutable versions
6. The supported data types in documents are: num, bool, String, null, DateTime, Array, Dictionary, 
   List, Map<String, dynamic>. The last two types must only contain the supported types. Blob is 
   currently not supported.
7. Queries are partially supported. The basic select, from, where and join clauses are supported. 
   Array functions, variable expressions, and array expressions are supported. Specifically, support 
   for group by, order by and limit hasn't been added yet. Full-text search is also not supported. 
   Below is an example query in Flutter using the couchify plugin:
```
QueryBuilder.select([
    SelectResult.expression(Expression.property("name").from("airline")),
    SelectResult.expression(Expression.property("callsign").from("airline")),
    SelectResult.expression(
        Expression.property("destinationairport").from("route")),
    SelectResult.expression(Expression.property("stops").from("route"))
  ]).from(DataSource.database(db).as("airline")).join([
    Join.join(DataSource.database(db).as("route"))
  ]).where(Expression.property("type")
      .from("route")
      .equalTo(Expression.string("route"))
      .and(Expression.property("type")
          .from("airline")
          .equalTo(Expression.string("airline")))
      .and(Expression.property("sourceairport")
          .from("route")
          .equalTo(Expression.string("RIX"))));
```

The QueryBuilder API is almost similar to the Couchbase Lite Android QueryBuilder API. You can
therefore follow their [tutorial](https://docs.couchbase.com/couchbase-lite/current/java/querybuilder.html) 
on how to use QueryBuilder and expect it to work in Flutter with almost no difference (except for the 
unsupported features, see below). The only major difference is that all methods that accept variable 
number of arguments in the Android version (such as the QueryBuilder.select() method), need to be passed 
the arguments as a list in the Flutter versions. For example, in the above query, arguments to both 
the QueryBuilder.select and the From.join methods are encapsulated in a list rather than passing directly.

## Roadmap

The features listed below are currently not supported, but they are part of the roadmap:

* batch transactions
* database and document change listeners
* support for sync gateway and peer-to-peer sync
* order by, group by and limit clauses in queries
* full-text search
* indexes
