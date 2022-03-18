package com.manul.couchify;

import android.content.Context;
import android.util.Log;

import java.sql.Time;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
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
    public String couchbaseLiteInit() {
      CouchbaseLite.init(applicationContext);
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
        if (document == null) {
          return Collections.emptyMap();
        }
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

    @Override
    public void deleteDatabase(String databaseId) {
      try {
        DatabaseManager.deleteDatabase(databaseId);
      } catch (Exception e) {
        e.printStackTrace();
      }
    }

    @Override
    public void deleteDocument(String databaseId, String documentId) {
      try {
        Database database = DatabaseManager.getDatabase(databaseId);
        database.delete(database.getDocument(documentId));
      } catch (Exception e) {
        e.printStackTrace();
      }
    }

    @Override
    public Long getCount(String databaseId) {
      try {
        return DatabaseManager.getDatabase(databaseId).getCount();
      } catch (Exception e) {
        e.printStackTrace();
      }
      return -1L;
    }
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) { }
}
