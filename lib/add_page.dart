import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;

  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _titleController = TextEditingController();
  bool isEdit = false;
  String? todoId;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      isEdit = true;
      _titleController.text = widget.todo!['todo'];
      todoId = widget.todo!['id'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? "Edit Todo" : "Add Todo",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Todo title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isEdit ? updateData : submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isEdit ? "Update" : "Submit",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ADD
  Future<void> submitData() async {
    final body = {
      "todo": _titleController.text,
      "completed": false,
      "userId": 1,
    };

    final uri = Uri.parse("https://dummyjson.com/todos/add");
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context, true);
    }
  }

  // UPDATE
  Future<void> updateData() async {
    final body = {"todo": _titleController.text, "completed": false};

    final uri = Uri.parse("https://dummyjson.com/todos/$todoId");
    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    }
  }
}
