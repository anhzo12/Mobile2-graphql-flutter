import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink httpLink = HttpLink(
    "https://api-us-west-2.hygraph.com/v2/clu7xy1tm000008jshwud8l6l/master");
final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  ),
);

// const String addPostMutation = """
// mutation createPost(\$title: String!, \$excerpt: String!, \$date: String!) {
//   createPost(
//     data: {
//       title: \$title,
//       excerpt: \$excerpt,
//       date: \$date
//     }
//   ) {
//     id
//   }
// }
// """;

const String addPostMutation = """
mutation createPost(\$title: String!, \$excerpt: String!){
  createPost(
    data: { title: \$title, excerpt: \$excerpt, date: "2024-03-26" }
  ) {
    id
  }
}
""";

class NewPostForm extends StatefulWidget {
  const NewPostForm({super.key});

  @override
  _NewPostFormState createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  late TextEditingController _titleController;
  late TextEditingController _excerptController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _excerptController = TextEditingController();
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
                'Add new post',
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
              Mutation(
                options: MutationOptions(document: gql(addPostMutation)),
                builder: (runMutation, result) {
                  return TextButton(
                    onPressed: () {
                      final title = _titleController.text;
                      final excerpt = _excerptController.text;
                      runMutation({
                        'title': title,
                        'excerpt': excerpt,
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  );
                },
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

// class NewPostForm extends StatelessWidget {
//   const NewPostForm({super.key});

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     return GraphQLProvider(
//         client: client,
//         child: Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: Container(
//                 height: height * 0.35,
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Text(
//                         'Thêm bài viết mới',
//                         style: TextStyle(
//                             fontSize: 24.0, fontWeight: FontWeight.bold),
//                       ),
//                       const TextField(
//                         decoration: InputDecoration(labelText: 'Tiêu đề'),
//                       ),
//                       const TextField(
//                         decoration: InputDecoration(labelText: 'Mô tả'),
//                       ),
//                       const SizedBox(height: 16.0),
//                       Mutation(
//                         options:
//                             MutationOptions(document: gql(addPostMutation)),
//                         builder: (runMutation, result) {
//                           return TextButton(
//                             onPressed: () {
//                               runMutation({});
//                             },
//                             child: const Text('Add'),
//                           );
//                         },
//                       ),
//                     ]))));
//   }
// }
