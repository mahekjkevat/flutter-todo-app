import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  List filteredItems = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Todo List",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // 🔍 SEARCH BAR (FIXED)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: searchController,
                      onChanged: searchTodo,
                      decoration: InputDecoration(
                        hintText: "Search todo...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  // 📃 LIST (SCROLLABLE)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: fetchTodo,
                      child: ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          final id = item['id'].toString();

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              title: Text(
                                item['todo'],
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                item['completed'] ? "Completed" : "Pending",
                              ),
                              trailing: PopupMenuButton(
                                onSelected: (value) {
                                  if (value == "edit") {
                                    navigateToEditPage(item);
                                  } else {
                                    deleteById(id);
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: "edit",
                                    child: Text("Edit"),
                                  ),
                                  PopupMenuItem(
                                    value: "delete",
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTodoPage()),
            );
            if (result == true) fetchTodo();
          },
        ),
      ),
    );
  }

  void navigateToEditPage(Map item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddTodoPage(todo: item)),
    );
    if (result == true) fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final uri = Uri.parse("https://dummyjson.com/todos/$id");
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      setState(() {
        items.removeWhere((e) => e['id'].toString() == id);
      });
    }
  }

  Future<void> fetchTodo() async {
    setState(() => isLoading = true);

    final uri = Uri.parse("https://dummyjson.com/todos");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        items = data['todos'];
        filteredItems = items;
        isLoading = false;
      });
    }
  }

  void searchTodo(String query) {
    setState(() {
      filteredItems = items.where((item) {
        return item['todo'].toString().toLowerCase().contains(
          query.toLowerCase(),
        );
      }).toList();
    });
  }
}
