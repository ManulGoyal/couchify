package com.manul.couchify.couchbase;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

import com.couchbase.lite.*;

public class QueryManager {
    private static final Map<String, ResultSet> resultSets = new HashMap<>();

    public static String executeQuery(Query query) throws Exception {
        String resultSetId = UUID.randomUUID().toString();
        resultSets.put(resultSetId, query.execute());

        return resultSetId;
    }

    public static ResultSetManager resultSet(String id) {
        return new ResultSetManager(id);
    }

    public static class ResultSetManager {
        String resultSetId;

        private ResultSetManager(String resultSetId) {
            this.resultSetId = resultSetId;
        }

        public Result next() {
            if (resultSets.containsKey(resultSetId)) {
                Result result = Objects.requireNonNull(resultSets.get(resultSetId)).next();
                if (result == null) {
                    resultSets.remove(resultSetId);
                }
                return result;
            }
            return null;
        }

        public List<Result> allResults() {
            if (resultSets.containsKey(resultSetId)) {
                List<Result> results = Objects.requireNonNull(resultSets.get(resultSetId))
                        .allResults();
                resultSets.remove(resultSetId);
                return results;
            }
            return null;
        }
    }
}
