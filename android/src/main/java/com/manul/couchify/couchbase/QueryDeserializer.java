package com.manul.couchify.couchbase;

import android.content.Context;
import android.util.Log;

import com.couchbase.lite.*;
import com.manul.couchify.couchbase.DatabaseManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class QueryDeserializer {
    private static final String TAG = "QueryDeserializer";
//    private final Context applicationContext;

    Set<String> aliases = new HashSet<>();
    List<Join> joinItems = new ArrayList<>();

//    public QueryDeserializer(Context context) {
//        applicationContext = context;
//    }

    private Expression deserializeArrayExpression(String operator, List<Object> expression) throws Exception {
        if (expression.size() != 4) 
            throw new Exception("Invalid array expression syntax");

        if (!(expression.get(1) instanceof String))
            throw new Exception("First operand of array expression must be the variable name (String)");

        VariableExpression variable = ArrayExpression.variable((String) expression.get(1));
        Expression arrayExpression = deserializeExpression(expression.get(2));
        Expression satisfies = deserializeExpression(expression.get(3));
        
        switch (operator) {
            case "ANY":
                return ArrayExpression.any(variable).in(arrayExpression).satisfies(satisfies);
            case "ANY AND EVERY":
                return ArrayExpression.anyAndEvery(variable).in(arrayExpression).satisfies(satisfies);
            case "EVERY":
                return ArrayExpression.every(variable).in(arrayExpression).satisfies(satisfies);
            default:
                throw new Exception("Unknown array expression operator: " + operator);
        }
    }
    
    private Expression deserializeFunctionExpression(String operator, List<Object> expression)
            throws Exception {
        switch (operator) {
            case "ARRAY_CONTAINS()":
                if (expression.size() != 3)
                    throw new Exception("Invalid ARRAY_CONTAINS() expression syntax");
                return ArrayFunction.contains(deserializeExpression(expression.get(1)),
                        deserializeExpression(expression.get(2)));
            case "ARRAY_LENGTH()":
                if (expression.size() != 2)
                    throw new Exception("Invalid ARRAY_LENGTH() expression syntax");
                return ArrayFunction.length(deserializeExpression(expression.get(1)));
            default:
                throw new Exception("Unknown function in expression: " + operator);
        }
    }

    private Expression deserializeOperatorExpression(String operator, List<Object> expression)
            throws Exception {
        switch (operator) {
            case "=":
                if (expression.size() != 3)
                    throw new Exception("Invalid equalTo expression syntax");
                return deserializeExpression(expression.get(1))
                        .equalTo(deserializeExpression(expression.get(2)));
            case "+":
                if (expression.size() != 3)
                    throw new Exception("Invalid add expression syntax");
                return deserializeExpression(expression.get(1))
                        .add(deserializeExpression(expression.get(2)));
            case "-":
                if (expression.size() != 3)
                    throw new Exception("Invalid subtract expression syntax");
                return deserializeExpression(expression.get(1))
                        .subtract(deserializeExpression(expression.get(2)));
            case "*":
                if (expression.size() != 3)
                    throw new Exception("Invalid multiply expression syntax");
                return deserializeExpression(expression.get(1))
                        .multiply(deserializeExpression(expression.get(2)));
            case "/":
                if (expression.size() != 3)
                    throw new Exception("Invalid divide expression syntax");
                return deserializeExpression(expression.get(1))
                        .divide(deserializeExpression(expression.get(2)));
            case "<":
                if (expression.size() != 3)
                    throw new Exception("Invalid lessThan expression syntax");
                return deserializeExpression(expression.get(1))
                        .lessThan(deserializeExpression(expression.get(2)));
            case ">":
                if (expression.size() != 3)
                    throw new Exception("Invalid greaterThan expression syntax");
                return deserializeExpression(expression.get(1))
                        .greaterThan(deserializeExpression(expression.get(2)));
            case "<=":
                if (expression.size() != 3)
                    throw new Exception("Invalid lessThanOrEqualTo expression syntax");
                return deserializeExpression(expression.get(1))
                        .lessThanOrEqualTo(deserializeExpression(expression.get(2)));
            case ">=":
                if (expression.size() != 3)
                    throw new Exception("Invalid greaterThanOrEqualTo expression syntax");
                return deserializeExpression(expression.get(1))
                        .greaterThanOrEqualTo(deserializeExpression(expression.get(2)));
            case "AND":
                if (expression.size() != 3)
                    throw new Exception("Invalid AND expression syntax");
                return deserializeExpression(expression.get(1))
                        .and(deserializeExpression(expression.get(2)));
            case "OR":
                if (expression.size() != 3)
                    throw new Exception("Invalid OR expression syntax");
                return deserializeExpression(expression.get(1))
                        .or(deserializeExpression(expression.get(2)));
            case "NOT":
                if (expression.size() != 2)
                    throw new Exception("Invalid NOT expression syntax");
                return Expression.not(deserializeExpression(expression.get(1)));
            case "!=":
                if (expression.size() != 3)
                    throw new Exception("Invalid notEqualTo expression syntax");
                return deserializeExpression(expression.get(1))
                        .notEqualTo(deserializeExpression(expression.get(2)));
            case "[]":
//                if (expression.size() == 1)
//                    return Expression.list(Collections.emptyList());
                List<Object> list = new ArrayList<>();
                for (int i = 1; i < expression.size(); i++) {
                    list.add(deserializeExpression(expression.get(i)));
                }
                return Expression.list(list);
            case "ANY":
            case "ANY AND EVERY":
            case "EVERY":
                return deserializeArrayExpression(operator, expression);
            default:
                throw new Exception("Unknown operator in expression: " + operator);
        }
    }

    private Expression deserializeComplexExpression(List<Object> expression) throws Exception {
        if (expression.isEmpty() || !(expression.get(0) instanceof String))
            throw new Exception("Invalid expression syntax");

        String operator = (String) expression.get(0);
        if (operator == null || operator.isEmpty())
            throw new Exception("Invalid expression syntax");

        if (operator.charAt(0) == '.')
            return deserializePropertyExpression(expression);

        if (operator.charAt(0) == '?')
            return deserializeVariableExpression(expression);

        if (operator.endsWith("()"))
            return deserializeFunctionExpression(operator, expression);

        return deserializeOperatorExpression(operator, expression);
    }

    private Expression deserializeSimpleExpression(Object expression) throws Exception {
        if (expression instanceof Integer)
            return Expression.intValue((int) expression);
        if (expression instanceof Boolean)
            return Expression.booleanValue((boolean) expression);
        if (expression instanceof String)
            return Expression.string((String) expression);
        if (expression instanceof Double)
            return Expression.doubleValue((double) expression);
        if (expression instanceof Float)
            return Expression.floatValue((float) expression);
        if (expression instanceof Long)
            return Expression.longValue((long) expression);
        if (expression instanceof Map) {
            Map<String, Object> map = (Map<String, Object>) expression;
            Map<String, Object> deserializedMap = new HashMap<>();
            for (Map.Entry<String, Object> entry : map.entrySet()) {
                deserializedMap.put(entry.getKey(),
                        deserializeExpression(entry.getValue()));
            }
            return Expression.map(deserializedMap);
        }

        throw new Exception("Unrecognized simple expression type");
    }

    private MetaExpression deserializeMetaExpression(String property) {
        switch (property) {
            case "_id":
                return Meta.id;
            case "_sequence":
                return Meta.sequence;
            case "_deleted":
                return Meta.deleted;
            case "_expiration":
                return Meta.expiration;
            default:
                return null;
        }
    }

    private Expression deserializePropertyExpression(List<Object> expression) throws Exception {
        if (expression.size() != 1)
            throw new Exception("Invalid property expression syntax");

        if (!(expression.get(0) instanceof String))
            throw new Exception("Invalid property expression syntax");

        String property = (String) expression.get(0);

        if (property.isEmpty())
            throw new Exception("Property path cannot be an empty string");

        if (property.charAt(0) != '.')
            throw new Exception("Property path must begin with a dot");

        if (property.equals("."))
            return Expression.all();

        if (property.endsWith("."))
            throw new Exception("Property path (except \".\") must not end with a dot");

        int endIndexOfRootComponent = property.indexOf('.', 1);

        if (endIndexOfRootComponent == -1) {
            // there is only one component in property path
            String component = property.substring(1);
            if (aliases.contains(component))
                return Expression.all().from(component);

            MetaExpression metaExpression = deserializeMetaExpression(component);
            if (metaExpression != null) return metaExpression;

            return Expression.property(component);
        } else {
            String rootComponent = property.substring(1, endIndexOfRootComponent);

            if (aliases.contains(rootComponent)) {
                int endIndexOfSecondComponent = property.indexOf('.', endIndexOfRootComponent + 1);

                if (endIndexOfSecondComponent == -1) {
                    MetaExpression metaExpression = deserializeMetaExpression(
                            property.substring(endIndexOfRootComponent + 1));
                    if (metaExpression != null) return metaExpression.from(rootComponent);
                }
                return Expression.property(property.substring(endIndexOfRootComponent + 1))
                        .from(rootComponent);
            }

            return Expression.property(property.substring(1));
        }
    }

    private VariableExpression deserializeVariableExpression(List<Object> expression)
            throws Exception {
        if (expression.size() != 1)
            throw new Exception("Invalid variable expression format");

        if (!(expression.get(0) instanceof String))
            throw new Exception("Invalid variable expression format");

        String variable = (String) expression.get(0);

        if (variable.isEmpty())
            throw new Exception("Variable expression cannot be an empty string");

        if (variable.charAt(0) != '?')
            throw new Exception("Variable expression must begin with a '?'");

        if (variable.length() == 1)
            throw new Exception("Variable name cannot be empty in a variable expression");

        return ArrayExpression.variable(variable.substring(1));
    }

    private Expression deserializeExpression(Object expression) throws Exception {
        if (expression == null)
            throw new Exception("Null expression found");

        if (expression instanceof List)
            return deserializeComplexExpression((List<Object>) expression);

        return deserializeSimpleExpression(expression);
    }

    private SelectResult deserializeWhatListItem(Object item) throws Exception {
        if (item instanceof String) {
            List<Object> propertyExpression = Collections.singletonList(item);
            return SelectResult.expression(
                    deserializePropertyExpression(propertyExpression));
        } else if (item instanceof List) {
            List<Object> expression = (List<Object>) item;
            if (expression.isEmpty() || !(expression.get(0) instanceof String))
                throw new Exception("Invalid WHAT list item syntax");

            String operator = (String) expression.get(0);

            if (operator.equals("AS")) {
                if (expression.size() != 3 || !(expression.get(2) instanceof String))
                    throw new Exception("Invalid syntax for alias expression in WHAT list");

                String alias = (String) expression.get(2);
                Expression selectExpression = deserializeExpression(expression.get(1));

                return SelectResult.expression(selectExpression).as(alias);
            } else {
                Expression selectExpression = deserializeExpression(expression);

                return SelectResult.expression(selectExpression);
            }
        } else if (item instanceof Map) {
            Map<String, Object> expression = (Map<String, Object>) item;
            Expression selectExpression = deserializeExpression(expression);

            return SelectResult.expression(selectExpression);
        } else {
            throw new Exception("Unknown item type in WHAT list");
        }
    }

    private List<SelectResult> deserializeWhatList(Map<String, Object> selectOperand) throws Exception {
        // TODO: WHAT field can be made optional
        if (!selectOperand.containsKey("WHAT"))
            throw new Exception("SELECT operand must contain WHAT field");

        if (!(selectOperand.get("WHAT") instanceof List))
            throw new Exception("Invalid WHAT syntax");
        List<Object> whatList = (List<Object>) selectOperand.get("WHAT");

        List<SelectResult> results = new ArrayList<>();

        for (Object item : whatList) {
            results.add(deserializeWhatListItem(item));
        }

        return results;
    }

    private Expression deserializeWhere(Map<String, Object> selectOperand) throws Exception {
        if (!selectOperand.containsKey("WHERE"))
            return null;

        return deserializeExpression(selectOperand.get("WHERE"));
    }

    private DataSource deserializeDataSource(Map<String, Object> source) throws Exception {
        if (!source.containsKey("COLLECTION"))
            throw new Exception("COLLECTION field missing in data source");

        if (!(source.get("COLLECTION") instanceof String))
            throw new Exception("COLLECTION must be a string");

//        DatabaseConfiguration config = new DatabaseConfiguration();

//        String dbPath = ((String) source.get("COLLECTION")).replace('\\', '/');
//        Log.i(TAG, "Parsing dbPath: " + dbPath);

        String databaseId = (String) source.get("COLLECTION");

//        if (dbPath.endsWith("/"))
//            throw new Exception("Invalid database path in COLLECTION");

//        int dbNamePosition = dbPath.lastIndexOf('/');

//        if (dbNamePosition != -1) {
//            String dbDir = dbPath.substring(0, dbNamePosition);
//            config.setDirectory(applicationContext.getFilesDir() + "/" + dbDir);
//
//            Log.i(TAG, "dbDir: " + dbDir);
//        }

//        String dbName = dbPath.substring(dbNamePosition + 1);
//        Log.i(TAG, "dbName: " + dbName);

        DataSource.As dataSource = DataSource.database(DatabaseManager.getDatabase(databaseId));

        if (source.containsKey("AS")) {
            if (!(source.get("AS") instanceof String))
                throw new Exception("Invalid syntax of AS field in data source");

            String alias = (String) source.get("AS");
            aliases.add(alias);
            return dataSource.as(alias);
        }

        return dataSource;
    }

    // TODO: implement deserialization of UNNEST
    private Join deserializeJoin(Map<String, Object> join) throws Exception {
        String joinType = "INNER";

        if (join.containsKey("JOIN")) {
            if(!(join.get("JOIN") instanceof String))
                throw new Exception("Invalid syntax of join item in FROM list");

            joinType = (String) join.get("JOIN");
        }

        if (!joinType.equals("CROSS") && !join.containsKey("ON"))
            throw new Exception("Missing ON field in join item in FROM list");

        DataSource dataSource = deserializeDataSource(join);
        Expression joinCondition = Expression.booleanValue(true);

        if(!joinType.equals("CROSS"))
            joinCondition = deserializeExpression(join.get("ON"));

        switch (joinType) {
            case "INNER":
                return Join.innerJoin(dataSource).on(joinCondition);
            case "LEFT OUTER":
                return Join.leftOuterJoin(dataSource).on(joinCondition);
            case "CROSS":
                return Join.crossJoin(dataSource);
            default:
                throw new Exception("Unknown JOIN type: " + joinType);
        }

    }

    private DataSource deserializeFromList(Map<String, Object> selectOperand) throws Exception {
        if (!selectOperand.containsKey("FROM"))
            throw new Exception("Missing FROM operand in SELECT operator");

        if (!(selectOperand.get("FROM") instanceof List))
            throw new Exception("Invalid FROM syntax");
        List<Object> fromList = (List<Object>) selectOperand.get("FROM");

        if (fromList.isEmpty())
            throw new Exception("FROM list must contain at least one item");

        if(!(fromList.get(0) instanceof Map))
            throw new Exception("Invalid FROM list item syntax");


        Map<String, Object> sourceItem = (Map<String, Object>) fromList.get(0);

        DataSource dataSource = deserializeDataSource(sourceItem);

        for (int i = 1; i < fromList.size(); i++) {
            if (!(fromList.get(i) instanceof Map))
                throw new Exception("Invalid FROM list item syntax");

            Map<String, Object> joinItem = (Map<String, Object>) fromList.get(i);

            joinItems.add(deserializeJoin(joinItem));
        }

        return dataSource;
    }

    public Query deserializeQuery(List<Object> query) {
        try {
            if (query == null || query.size() != 2 || !(query.get(0) instanceof String)
                    || !(query.get(1) instanceof Map))
                throw new Exception("Invalid query syntax");

            String operator = (String) query.get(0);
            Map<String, Object> operand = (Map<String, Object>) query.get(1);

            if (!operator.equals("SELECT"))
                throw new Exception("Top-level operator must be SELECT");

            DataSource dataSource = deserializeFromList(operand);
            List<SelectResult> results = deserializeWhatList(operand);
            Expression condition = deserializeWhere(operand);

            Query deserializedQuery =
                    QueryBuilder.select(results.toArray(new SelectResult[0])).from(dataSource);

            if (!joinItems.isEmpty())
                deserializedQuery = ((From) deserializedQuery).join(joinItems.toArray(new Join[0]));

            if (condition != null) {
                if (deserializedQuery instanceof From)
                    deserializedQuery = ((From) deserializedQuery).where(condition);
                else
                    deserializedQuery = ((Joins) deserializedQuery).where(condition);
            }

            return deserializedQuery;
        } catch (Exception e) {
            e.printStackTrace();
            Log.e(TAG, "Unable to deserialize query received from Flutter activity");
        }

        return null;
    }
}
