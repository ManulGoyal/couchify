package com.manul.couchify.couchbase;

import com.couchbase.lite.Database;
import com.couchbase.lite.DatabaseConfiguration;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class DatabaseManager {
    private static final Map<String, Database> databases = new HashMap<>();

    public static Database getDatabase(String id) throws Exception {
        if (databases.containsKey(id))
            return databases.get(id);
        throw new Exception("Database with id " + id + " isn't open");
    }

    public static void openDatabase(String id) throws Exception {
        if (databases.containsKey(id))
            return;

        int lastIndexOfSlash = Math.max(id.lastIndexOf('/'), id.lastIndexOf('\\'));
        if (lastIndexOfSlash == -1)
            throw new Exception("Invalid database id: " + id);

        String name = id.substring(lastIndexOfSlash + 1);
        String directory = id.substring(0, lastIndexOfSlash);

        DatabaseConfiguration config = new DatabaseConfiguration().setDirectory(directory);
        databases.put(id, new Database(name, config));
    }

    public static void closeDatabase(String id) throws Exception {
        if (databases.containsKey(id)) {
            Database database = databases.get(id);
            Objects.requireNonNull(database).close();
            databases.remove(id);
        } else {
            throw new Exception("Database with id " + id + " isn't open");
        }
    }

    public static void deleteDatabase(String id) throws Exception {
        if (databases.containsKey(id)) {
            Database database = databases.get(id);
            Objects.requireNonNull(database).delete();
            databases.remove(id);
        } else {
            throw new Exception("Database with id " + id + " isn't open");
        }
    }
}
