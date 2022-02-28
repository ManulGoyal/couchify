# couchify

Couchify is a Couchbase Lite API for Flutter developers. The objective is to keep the Flutter API as
close as possible to the official Android (Java) API provided by Couchbase Lite, so that anyone familiar
with that API can easily use the Flutter API. The plugin uses Couchbase Lite Android EE 2.8.5.
Currently the plugin only supports Android and is not available for iOS.

## Getting Started

1. Depend on it:
```
couchify:
    git: https://github.com/ManulGoyal/couchify
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
Query query = QueryBuilder.select([SelectResult.expression(Meta.id), SelectResult.all()])
  .from(DataSource.database(db));

// execute the query to get a ResultSet
ResultSet rs = await query.execute();

// iterate over the result set and print contents of each result as a Map
await for (Result result in rs.getStream()) {
   print(result.toMap());
}
```

## Note

This plugin is under development. Currently, the following features are supported:

1. Creating mutable documents, fetching documents by id from a database and saving documents to the 
   database
2. Having multiple different databases open at the same time (by creating multiple Database objects)
3. Queries are partially supported. The basic select, from, where and join clauses are supported.
   Specifically, support for group by, order by and limit hasn't been added yet. Below is an example
   query in Flutter using the couchify plugin:
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
therefore follow their tutorial on how to use QueryBuilder and expect it to work in Flutter with almost
no difference. The only major difference is that all methods that accept variable number of arguments
in the Android version (such as the QueryBuilder.select() method), need to be passed the arguments as
a list in the Flutter versions. For example, in the above query, arguments to both the QueryBuilder.select 
and the From.join methods are encapsulated in a list rather than passing directly.

Future plans include adding support for batch transactions, replicator APIs and a complete query API.

I would love to hear feedback and am open to specific requests. 