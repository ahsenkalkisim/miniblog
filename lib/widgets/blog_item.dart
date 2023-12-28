import 'package:flutter/material.dart';
import 'package:mini_blog/models/blog.dart';

class BlogItem extends StatelessWidget {
  const BlogItem({Key? key, required this.blog}) : super(key: key);

  final Blog blog; //artık blog ile diğer Bloga erisim hakkı tanındı

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 90, 49, 161),
      elevation: 20,
      shadowColor: Colors.blueGrey,
      child: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 74, 122, 206),
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Image.network(blog.thumbnail!),
            ), //null da olabilir başka bir şeyde olabilir
          ),
          ListTile(
            title: Text(blog.title!),
            subtitle: Text(blog.author!),
          ),
        ],
      ),
    );
  }
}
