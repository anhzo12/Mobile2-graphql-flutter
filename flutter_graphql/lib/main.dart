import 'widgets/blog_row.dart';
import 'widgets/add_blog.dart';
import 'hygraph_cofig.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

const String query = """
query Content{
  posts{
    id
    title
    excerpt
  }
}
""";

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
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
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const MyApp()),
                    );
                  },
                ),
              ],
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
                            final id = post['id'];
                            final title = post['title'];
                            final excerpt = post['excerpt'];
                            // final coverImageURL = post!['coverImage']['url'];
                            return BlogRow(
                              id: id,
                              title: title,
                              excerpt: excerpt,
                              // coverURL: coverImageURL,
                            );
                          },
                        );
                      })),
              //   Mutation(
              //       options: MutationOptions(document: gql(updatePostMutation)),
              //       builder: (runMutation, result) {
              //         return TextButton(
              //           onPressed: () {
              //             runMutation({
              //               'id': 'clu9z594rembh08ltqgqj4e7k',
              //               'title': 'New Title for the Post',
              //             });
              //           },
              //           child: const Text('Update Author Name'),
              //         );
              //       })
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
