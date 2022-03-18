import 'package:couchify/couchify.dart';

class TodoListItem {
  String? id;
  String? title;
  List<String>? tags;
  DateTime? created;
  bool isSelected = false;

  TodoListItem(
      {required this.title, required this.tags, required this.created});

  TodoListItem.fromMap(Map<String, dynamic> data) {
    id = data['id'] as String;
    title = data['title'] as String;
    tags = List<String>.from(data['tags'] as List);
    created = DateTime.tryParse(data['created'] as String);
  }
}

class DatabaseManager {
  final Database database;

  DatabaseManager(this.database);

  Future<List<TodoListItem>> getItems() async {
    var query = QueryBuilder.select([
      SelectResult.expression(Meta.id),
      SelectResult.property("title"),
      SelectResult.property("tags"),
      SelectResult.property("created"),
    ]).from(DataSource.database(database)).where(
        Expression.property("type").equalTo(Expression.string("todo_item")));

    var resultSet = await query.execute();
    var results = await resultSet.allResults();

    return results.map((e) => TodoListItem.fromMap(e.toMap())).toList();
  }

  Future addItem(TodoListItem item) async {
    var tagsArray = MutableArray.data(item.tags!);
    var document = MutableDocument()
        .setString('title', item.title!)
        .setArray('tags', tagsArray)
        .setString('type', 'todo_item')
        .setDate("created", item.created!);
    await database.save(document);
  }

  Future deleteItem(TodoListItem item) async {
    var document = await database.getDocument(item.id!);
    if (document != null) await database.deleteDocument(document);
  }

  Future updateItem(TodoListItem item) async {
    var document = await database.getDocument(item.id!);
    if (document != null) {
      var tagsArray = MutableArray.data(item.tags!);
      var updatedDocument = document
          .toMutable()
          .setString('title', item.title!)
          .setArray('tags', tagsArray);
      await database.save(updatedDocument);
    }
  }

  Future queryByTitleOrTag(String queryString) async {
    // create a variable expression named "tag"
    var tag = ArrayExpression.variable("tag");

    // query for all to-do list items that either have their title starting with
    // queryString, or whose tag list contains queryString
    var query = QueryBuilder.select([
      SelectResult.expression(Meta.id),
      SelectResult.property("title"),
      SelectResult.property("tags"),
      SelectResult.property("created"),
    ]).from(DataSource.database(database)).where(Expression.property("type")
        .equalTo(Expression.string("todo_item"))
        .and(Expression.property("title")
            .like(Expression.string("$queryString%"))
            .or(ArrayFunction.contains(
                Expression.property("tags"), Expression.string(queryString)))));

    var resultSet = await query.execute();
    var results = await resultSet.allResults();

    return results.map((e) => TodoListItem.fromMap(e.toMap())).toList();
  }
}
