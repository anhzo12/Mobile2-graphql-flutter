import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'widgets/blog_row.dart';
import 'widgets/add_blog.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

final HttpLink httpLink = HttpLink(
    "https://api-us-west-2.hygraph.com/v2/clu7xy1tm000008jshwud8l6l/master");
final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  ),
);

const String query = """
query Content{
  posts{
    id
    title
    excerpt
  }
}
""";

const String updatePostMutation = """
mutation updatePost{
  updatePost(
    where: { id: "clu9z594rembh08ltqgqj4e7k" }
    data: { title: "dsvdvff Asaolu" }
  ) {
    id
  }
}
""";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
          title: 'GraphQL Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Hygraph Blog",
              ),
            ),
            body: Column(children: [
              Expanded(
                  child: Query(
                      options: QueryOptions(
                          document: gql(query),
                          variables: const <String, dynamic>{
                            "variableName": "value"
                          }),
                      builder: (result, {fetchMore, refetch}) {
                        if (result.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (result.data == null) {
                          return const Center(
                            child: Text("No article found!"),
                          );
                        }
                        final posts = result.data!['posts'];
                        return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            final title = post['title'];
                            final excerpt = post['excerpt'];
                            // final coverImageURL = post!['coverImage']['url'];
                            return BlogRow(
                              title: title,
                              excerpt: excerpt,
                              // coverURL: coverImageURL,
                            );
                          },
                        );
                      })),
              Mutation(
                  options: MutationOptions(document: gql(updatePostMutation)),
                  builder: (runMutation, result) {
                    return TextButton(
                      onPressed: () {
                        runMutation({
                          'id': 'clu9z594rembh08ltqgqj4e7k',
                          'title': 'New Title for the Post',
                        });
                      },
                      child: const Text('Update Author Name'),
                    );
                  })
            ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return const NewPostForm();
                  },
                );
              },
              child: const Icon(Icons.add),
            ),
          )),
    );
  }
}
