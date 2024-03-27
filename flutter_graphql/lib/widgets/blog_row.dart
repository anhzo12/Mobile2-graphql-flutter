import 'package:flutter/material.dart';
import 'package:flutter_graphql/widgets/edit_blog.dart';

class BlogRow extends StatelessWidget {
  final String id;
  final String title;
  final String excerpt;
  // final String coverURL;

  const BlogRow({
    super.key,
    required this.id,
    required this.title,
    required this.excerpt,
    // required this.coverURL,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return EditPostForm(
                id: id,
                title: title,
                excerpt: excerpt,
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Expanded(
              //   flex: 1,
              //   child: coverURL != null
              //       ? Image.network(coverURL)
              //       : const FlutterLogo(),
              // ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      excerpt,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
