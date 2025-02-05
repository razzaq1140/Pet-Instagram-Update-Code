import 'dart:convert'; // Add this import for jsonDecode

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/quill_delta.dart';

class QuillEditorPage extends StatefulWidget {
  final String initialData;

  const QuillEditorPage({super.key, required this.initialData});

  @override
  QuillEditorPageState createState() => QuillEditorPageState();
}

class QuillEditorPageState extends State<QuillEditorPage> {
  late quill.QuillController _quillController;

  @override
  void initState() {
    super.initState();

    // Initialize the QuillController with the initial data
    _quillController = quill.QuillController(
      document: _getDocumentFromInitialData(widget.initialData),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  quill.Document _getDocumentFromInitialData(String initialData) {
    try {
      // Try to decode the initialData as JSON
      final decodedData = jsonDecode(initialData);
      // If decoding is successful, return the document from delta
      return quill.Document.fromDelta(Delta.fromJson(decodedData as List<dynamic>));
    } catch (e) {
      // If decoding fails, treat initialData as plain text
      return quill.Document()..insert(0, initialData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Description'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Save the current content of the Quill editor and return it
              var editedData = jsonEncode(_quillController.document.toDelta().toJson());
              Navigator.pop(context, editedData); // Pass back to AddProductPage
            },
          ),
        ],
      ),
      body: Column(
        children: [
          quill.QuillToolbar.simple(controller: _quillController),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              child: quill.QuillEditor.basic(
                controller: _quillController,
             //  readOnly: false, // Make the editor editable
              ),
            ),
          ),
        ],
      ),
    );
  }
}
