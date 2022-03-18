# couchify_example

This is an example app demonstrating how to use the couchify plugin. It is a simple to-do list app
that shows the basic CRUD operations on to-do items, stored locally in a Couchbase Lite database.
Each to-do item comprises of a title, a list of tags, and the creation date. The app also has a
basic search feature, that allows the user to enter a search term, which retrieves only those
items whose title either begins with that term or whose tag list contains that term. This example
shows how to:
* open a new or existing database locally
* create, retrieve, update and delete documents in the database
* create queries using `QueryBuilder` and reading from the `ResultSet`