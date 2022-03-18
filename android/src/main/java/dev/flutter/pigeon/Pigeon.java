// Autogenerated from Pigeon (v1.0.18), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package dev.flutter.pigeon;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class Pigeon {
  private static class CouchbaseLiteWrapperCodec extends StandardMessageCodec {
    public static final CouchbaseLiteWrapperCodec INSTANCE = new CouchbaseLiteWrapperCodec();
    private CouchbaseLiteWrapperCodec() {}
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter.*/
  public interface CouchbaseLiteWrapper {
    String couchbaseLiteInit();
    String getDatabasePath(String id);
    void openDatabase(String id);
    void closeDatabase(String id);
    String executeQuery(List<Object> query);
    List<Object> resultSetAllResults(String resultSetId);
    Map<String, Object> resultSetNext(String resultSetId);
    void saveDocument(String databaseId, String documentId, Map<String, Object> document);
    Map<String, Object> getDocument(String databaseId, String documentId);
    void deleteDatabase(String databaseId);
    void deleteDocument(String databaseId, String documentId);
    Long getCount(String databaseId);

    /** The codec used by CouchbaseLiteWrapper. */
    static MessageCodec<Object> getCodec() {
      return CouchbaseLiteWrapperCodec.INSTANCE;
    }

    /** Sets up an instance of `CouchbaseLiteWrapper` to handle messages through the `binaryMessenger`. */
    static void setup(BinaryMessenger binaryMessenger, CouchbaseLiteWrapper api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CouchbaseLiteWrapper.couchbaseLiteInit", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              String output = api.couchbaseLiteInit();
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CouchbaseLiteWrapper.getDatabasePath", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String idArg = (String)args.get(0);
              if (idArg == null) {
                throw new NullPointerException("idArg unexpectedly null.");
              }
              String output = api.getDatabasePath(idArg);
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CouchbaseLiteWrapper.openDatabase", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String idArg = (String)args.get(0);
              if (idArg == null) {
                throw new NullPointerException("idArg unexpectedly null.");
              }
              api.openDatabase(idArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CouchbaseLiteWrapper.closeDatabase", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String idArg = (String)args.get(0);
              if (idArg == null) {
                throw new NullPointerException("idArg unexpectedly null.");
              }
              api.closeDatabase(idArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CouchbaseLiteWrapper.executeQuery", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              List<Object> queryArg = (List<Object>)args.get(0);
              if (queryArg == null) {
                throw new NullPointerException("queryArg unexpectedly null.");
              }
              String output = api.executeQuery(queryArg);
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CouchbaseLiteWrapper.resultSetAllResults", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String resultSetIdArg = (String)args.get(0);
              if (resultSetIdArg == null) {
                throw new NullPointerException("resultSetIdArg unexpectedly null.");
              }
              List<Object> output = api.resultSetAllResults(resultSetIdArg);
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CouchbaseLiteWrapper.resultSetNext", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String resultSetIdArg = (String)args.get(0);
              if (resultSetIdArg == null) {
                throw new NullPointerException("resultSetIdArg unexpectedly null.");
              }
              Map<String, Object> output = api.resultSetNext(resultSetIdArg);
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CouchbaseLiteWrapper.saveDocument", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String databaseIdArg = (String)args.get(0);
              if (databaseIdArg == null) {
                throw new NullPointerException("databaseIdArg unexpectedly null.");
              }
              String documentIdArg = (String)args.get(1);
              if (documentIdArg == null) {
                throw new NullPointerException("documentIdArg unexpectedly null.");
              }
              Map<String, Object> documentArg = (Map<String, Object>)args.get(2);
              if (documentArg == null) {
                throw new NullPointerException("documentArg unexpectedly null.");
              }
              api.saveDocument(databaseIdArg, documentIdArg, documentArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CouchbaseLiteWrapper.getDocument", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String databaseIdArg = (String)args.get(0);
              if (databaseIdArg == null) {
                throw new NullPointerException("databaseIdArg unexpectedly null.");
              }
              String documentIdArg = (String)args.get(1);
              if (documentIdArg == null) {
                throw new NullPointerException("documentIdArg unexpectedly null.");
              }
              Map<String, Object> output = api.getDocument(databaseIdArg, documentIdArg);
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CouchbaseLiteWrapper.deleteDatabase", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String databaseIdArg = (String)args.get(0);
              if (databaseIdArg == null) {
                throw new NullPointerException("databaseIdArg unexpectedly null.");
              }
              api.deleteDatabase(databaseIdArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CouchbaseLiteWrapper.deleteDocument", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String databaseIdArg = (String)args.get(0);
              if (databaseIdArg == null) {
                throw new NullPointerException("databaseIdArg unexpectedly null.");
              }
              String documentIdArg = (String)args.get(1);
              if (documentIdArg == null) {
                throw new NullPointerException("documentIdArg unexpectedly null.");
              }
              api.deleteDocument(databaseIdArg, documentIdArg);
              wrapped.put("result", null);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.CouchbaseLiteWrapper.getCount", getCodec());
        if (api != null) {
          channel.setMessageHandler((message, reply) -> {
            Map<String, Object> wrapped = new HashMap<>();
            try {
              ArrayList<Object> args = (ArrayList<Object>)message;
              String databaseIdArg = (String)args.get(0);
              if (databaseIdArg == null) {
                throw new NullPointerException("databaseIdArg unexpectedly null.");
              }
              Long output = api.getCount(databaseIdArg);
              wrapped.put("result", output);
            }
            catch (Error | RuntimeException exception) {
              wrapped.put("error", wrapError(exception));
            }
            reply.reply(wrapped);
          });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }
  private static Map<String, Object> wrapError(Throwable exception) {
    Map<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put("details", "Cause: " + exception.getCause() + ", Stacktrace: " + Log.getStackTraceString(exception));
    return errorMap;
  }
}
