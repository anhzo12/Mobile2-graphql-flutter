import 'package:flutter/material.dart';
import 'package:flutter_graphql/hygraph_cofig.dart';
import 'package:flutter_graphql/main.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String updatePostMutation = """
mutation updatePost(\$id: ID!, \$title: String!, \$excerpt: String!){
  updatePost(
    where: { id: \$id }
    data: { title: \$title, excerpt: \$excerpt }
  ) {
    id
  }
}
""";

const String deletePostMutation = """
mutation deletePost(\$id: ID!) {
  deletePost(where: {id: \$id}) {
    id
  }
}
""";

class EditPostForm extends StatefulWidget {
  final String id;
  final String title;
  final String excerpt;
  const EditPostForm({
    super.key,
    required this.id,
    required this.title,
    required this.excerpt,
  });

  @override
  _EditPostFormState createState() => _EditPostFormState();
}

class _EditPostFormState extends State<EditPostForm> {
  late TextEditingController _titleController;
  late TextEditingController _excerptController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _excerptController = TextEditingController(text: widget.excerpt);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _excerptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit post',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _excerptController,
                decoration: const InputDecoration(labelText: 'Excerpt'),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Mutation(
                    options: MutationOptions(
                      document: gql(updatePostMutation),
                      onError: (error) {
                        print("Error occurred: $error");
                      },
                      onCompleted: (sussess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const MyApp()),
                        );
                      },
                    ),
                    builder: (runMutation, result) {
                      return OutlinedButton(
                        onPressed: () {
                          final title = _titleController.text;
                          final excerpt = _excerptController.text;
                          runMutation({
                            'id': widget.id.toString(),
                            'title': title,
                            'excerpt': excerpt,
                          });
                          // Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  Mutation(
                    options: MutationOptions(
                      document: gql(deletePostMutation),
                      onError: (error) {
                        print("Error occurred: $error");
                      },
                      onCompleted: (sussess) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => const MyApp()),
                        );
                      },
                    ),
                    builder: (runMutation, result) {
                      return OutlinedButton(
                        onPressed: () {
                          runMutation({
                            'id': widget.id,
                          });
                          // Navigator.pop(context);
                        },
                        child: const Text('Delete'),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
