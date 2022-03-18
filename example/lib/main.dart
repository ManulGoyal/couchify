import 'package:couchify_example/database_manager.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// package used for formatting dates, not required for couchify
import 'package:intl/intl.dart';

// importing couchify plugin
import 'package:couchify/couchify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String dbName = "todoListDb";
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoListViewer(dbName: dbName),
    );
  }
}

class TodoListViewer extends StatefulWidget {
  final String dbName;

  const TodoListViewer({Key? key, required this.dbName}) : super(key: key);

  @override
  State<TodoListViewer> createState() => _TodoListViewerState();
}

class _TodoListViewerState extends State<TodoListViewer> {
  bool _initialized = false;
  DatabaseManager? _dbManager;
  List<TodoListItem>? _todoList;
  int _selectedItemsCount = 0;
  bool _searchMode = false;
  final _queryController = TextEditingController();
  final _dateFormat = DateFormat(DateFormat.ABBR_MONTH_DAY);

  @override
  void initState() {
    super.initState();
    CouchbaseLite.init().then((value) {
      var configuration = DatabaseConfiguration();
      return Database.open(widget.dbName, configuration);
    }).then((database) {
      _dbManager = DatabaseManager(database);
      return _fetchTodoList();
    }).then((value) {
      setState(() {
        _initialized = true;
      });
    });
  }

  Future _fetchTodoList() async {
    var items = await _dbManager!.getItems();
    setState(() {
      _todoList = items;
      _selectedItemsCount = 0;
    });
  }

  Future _addItem(String title, String tags) async {
    var item = TodoListItem(
        title: title, tags: tags.split(","), created: DateTime.now());
    await _dbManager?.addItem(item);
    await _fetchTodoList();
    print(_todoList);
  }

  Future _deleteItems() async {
    await Future.forEach(_todoList!.where((item) => item.isSelected),
        (TodoListItem item) async {
      return _dbManager?.deleteItem(item);
    });
    if (_searchMode) {
      await _queryItems(_queryController.text);
    } else {
      await _fetchTodoList();
    }
  }

  Future _updateItem(TodoListItem item, String title, String tags) async {
    item.title = title;
    item.tags = tags.split(",");
    await _dbManager?.updateItem(item);
    await _fetchTodoList();
  }

  Future _queryItems(String query) async {
    var items = await _dbManager!.queryByTitleOrTag(query);
    setState(() {
      _todoList = items;
      _selectedItemsCount = 0;
    });
  }

  void _showCreateTodoListItemModal() {
    var titleController = TextEditingController();
    var tagsController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 250,
            color: Colors.amber,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Create New Item',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "Title",
                        // focusedBorder: OutlineInputBorder(),
                        // enabledBorder: OutlineInputBorder(),
                      ),
                    ),
                    TextField(
                      controller: tagsController,
                      decoration: const InputDecoration(
                        hintText: "Tags (comma-separated)",
                        // focusedBorder: OutlineInputBorder(),
                        // enabledBorder: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    ElevatedButton(
                      child: const Text('Create'),
                      onPressed: () {
                        _addItem(titleController.text, tagsController.text);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditTodoListItemModal(TodoListItem item) {
    var titleController = TextEditingController(text: item.title!);
    var tagsController = TextEditingController(text: item.tags!.join(','));
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 250,
            color: Colors.amber,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Edit Item',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "Title",
                        // focusedBorder: OutlineInputBorder(),
                        // enabledBorder: OutlineInputBorder(),
                      ),
                    ),
                    TextField(
                      controller: tagsController,
                      decoration: const InputDecoration(
                        hintText: "Tags (comma-separated)",
                        // focusedBorder: OutlineInputBorder(),
                        // enabledBorder: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    ElevatedButton(
                      child: const Text('Create'),
                      onPressed: () {
                        _updateItem(
                            item, titleController.text, tagsController.text);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _searchMode
          ? AppBar(
              title: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _queryController,
                cursorColor: Colors.white,
                autofocus: true,
                onChanged: (queryString) {
                  _queryItems(queryString);
                },
                decoration: const InputDecoration(
                  hintText: "Search by title or tag...",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    _searchMode = false;
                    _fetchTodoList();
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              actions: _selectedItemsCount > 0
                  ? <Widget>[
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteItems();
                        },
                      )
                    ]
                  : null,
            )
          : AppBar(
              title: const Text("To-do List App Example"),
              actions: <Widget>[
                _selectedItemsCount > 0
                    ? IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteItems();
                        },
                      )
                    : IconButton(
                        onPressed: () {
                          _queryController.clear();
                          setState(() {
                            _searchMode = true;
                          });
                        },
                        icon: const Icon(Icons.search),
                      ),
              ],
            ),
      body: !_initialized
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                return;
              },
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    onChanged: (checked) {
                      setState(() {
                        _todoList![index].isSelected = checked ?? false;
                        _selectedItemsCount +=
                            _todoList![index].isSelected ? 1 : -1;
                      });
                    },
                    value: _todoList![index].isSelected,
                    controlAffinity: ListTileControlAffinity.leading,
                    secondary:
                        Text(_dateFormat.format(_todoList![index].created!)),
                    title: Text(_todoList![index].title!),
                    subtitle:
                        Text('Tags: ' + _todoList![index].tags!.join(', ')),
                  );
                },
                itemCount: _todoList!.length,
              ),
            ),
      floatingActionButton: _initialized
          ? (_selectedItemsCount <= 1
              ? (_selectedItemsCount == 0
                  ? FloatingActionButton(
                      onPressed: _showCreateTodoListItemModal,
                      child: const Icon(Icons.add))
                  : FloatingActionButton(
                      onPressed: () {
                        var item = _todoList!
                            .where((element) => element.isSelected)
                            .single;
                        _showEditTodoListItemModal(item);
                      },
                      child: const Icon(Icons.edit)))
              : null)
          : null,
    );
  }
}
