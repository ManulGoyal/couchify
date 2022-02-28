package com.manul.couchify;

import android.content.Context;
import android.util.Log;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import androidx.annotation.NonNull;

import dev.flutter.pigeon.Pigeon;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

import com.couchbase.lite.*;
import com.manul.couchify.couchbase.*;

/** CouchifyPlugin */
public class CouchifyPlugin implements FlutterPlugin {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
//  private MethodChannel channel;

  private Context applicationContext;
  private static final String TAG = "MainActivity";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
//    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "couchify");
//    channel.setMethodCallHandler(this);
    this.applicationContext = flutterPluginBinding.getApplicationContext();
    Pigeon.CouchbaseLiteWrapper.setup(
            flutterPluginBinding.getBinaryMessenger(),
            new CouchifyPlugin.CouchbaseLiteWrapperDefault());
  }

  private class CouchbaseLiteWrapperDefault implements Pigeon.CouchbaseLiteWrapper {

    @Override
    public Long getValue() {
      List<Object> ls = new ArrayList<>();
      ls.add(45.0);
      ls.add(Expression.intValue(30).add(Expression.intValue(37)));
//            ls.add("manul");
//            ls.add(Expression.intValue(56));
//            ls.add(Expression.not(Expression.booleanValue(true)));
      DatabaseConfiguration config = new DatabaseConfiguration();
      config.setDirectory(applicationContext.getFilesDir() + "/tempDir");
      try {
        Database db = new Database("tempDb", config);
        if (db.getDocument("testdoc2") == null) {
          MutableDocument doc = new MutableDocument("testdoc2");
          Log.i(TAG, doc.getId());
          Log.i(TAG, doc.toMap().toString());
          MutableArray arr = new MutableArray();
          arr.addInt(45);
          arr.addInt(67);
          doc.setArray("arrayprop", arr);
          db.save(doc);
        }

        MutableDocument doc = new MutableDocument();
        Log.i(TAG, doc.getId());
        Log.i(TAG, doc.toMap().toString());
        doc.setString("id", "manul");
        Log.i(TAG, doc.getId());
        Log.i(TAG, doc.toMap().toString());

        Log.i(TAG, db.getPath());

//                ResultSet rs = QueryBuilder.select(SelectResult.expression(Meta.id)).from(DataSource.database(db))
//                        .where(Expression.property("arrayprop").equalTo(Expression.list(ls))).execute();

        VariableExpression variable = ArrayExpression.variable("var");
        ResultSet rs = QueryBuilder.select(SelectResult.expression(Meta.id)).from(DataSource.database(db))
                .where(ArrayFunction.contains(Expression.list(ls), Expression.intValue(67))).execute();

//                ResultSet rs = QueryBuilder.select(SelectResult.expression(Expression.list(ls))).from(DataSource.database(db)).execute();
        List<Result> rss = rs.allResults();
        for (Result r : rss) {
          Log.i(TAG, String.valueOf(r));
          Log.i(TAG, r.getString("id"));
//                    Log.i(TAG, r.getString("_id"));

          Log.i(TAG, r.toMap().toString());
        }
      } catch (CouchbaseLiteException e) {
        e.printStackTrace();

      }


      return 6L;
    }

    @Override
    public String couchbaseLiteInit() {
      CouchbaseLite.init(applicationContext);
//      Log.i(TAG, applicationContext.getFilesDir().toString());
//      Log.i(TAG, applicationContext.getFilesDir().getPath());
//      Log.i(TAG, applicationContext.getFilesDir().getAbsolutePath());
//      try {
//        Log.i(TAG, applicationContext.getFilesDir().getCanonicalPath());
//      } catch (Exception exception){
//        exception.printStackTrace();
//      }
      return applicationContext.getFilesDir().toString();
    }

    @Override
    public String getDatabasePath(String id) {
      try {
        return DatabaseManager.getDatabase(id).getPath();
      } catch (Exception e) {
        e.printStackTrace();
        return "";
      }
    }

    @Override
    public void openDatabase(String id) {
      try {
        DatabaseManager.openDatabase(id);
      } catch (Exception e) {
        e.printStackTrace();
      }
    }

    @Override
    public void closeDatabase(String id) {
      try {
        DatabaseManager.closeDatabase(id);
      } catch (Exception e) {
        e.printStackTrace();
      }
    }

    @Override
    public Map<String, Object> getDocument(String databaseId, String documentId) {
      try {
        Document document = DatabaseManager.getDatabase(databaseId).getDocument(documentId);
        Map<String, Object> documentMap = new HashMap<>();
        documentMap.put("id", document.getId());
        documentMap.put("data", document.toMap());

        return documentMap;
      } catch (Exception e) {
        e.printStackTrace();
      }
      return Collections.emptyMap();
    }

    @Override
    public String executeQuery(List<Object> query) {
      QueryDeserializer deserializer = new QueryDeserializer();

      Query deserializedQuery = deserializer.deserializeQuery(query);

      if (deserializedQuery == null) {
        Log.e(TAG, "Unable to execute query");
        return "";
      }

      try {
//        ResultSet results = deserializedQuery.execute();
//
//        List<Object> resultList = new ArrayList<>();
//
//        for (Result result : results) {
////          Log.i(TAG, result.toMap().getClass().getName());
//          resultList.add(result.toMap());
//        }
//
//        return resultList;
        return QueryManager.executeQuery(deserializedQuery);
      } catch (Exception e) {
        e.printStackTrace();
        Log.e(TAG, "Unable to execute query");
      }

      return "";
    }

    @Override
    public List<Object> resultSetAllResults(String resultSetId) {
      List<Result> allResults = QueryManager.resultSet(resultSetId).allResults();
      if (allResults == null) return Collections.emptyList();
      List<Object> resultList = new ArrayList<>();

      for (Result result : allResults) {
        resultList.add(result.toMap());
      }

      return resultList;
    }

    @Override
    public Map<String, Object> resultSetNext(String resultSetId) {
      Result result = QueryManager.resultSet(resultSetId).next();
      if (result == null) return Collections.emptyMap();
      return result.toMap();
    }

    @Override
    public void saveDocument(String databaseId, String documentId, Map<String, Object> document) {
      try {
        Database database = DatabaseManager.getDatabase(databaseId);
        database.save(new MutableDocument(documentId, document));
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) { }
}
