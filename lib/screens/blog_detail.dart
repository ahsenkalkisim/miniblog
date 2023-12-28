import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mini_blog/models/blog.dart';
import 'package:http/http.dart' as http;

//http olarak

class BlogDetail extends StatefulWidget {
  const BlogDetail({Key? key, required this.blogId}) : super(key: key);
  final String blogId;

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  @override
  void initState() {
    fetchBlogs();
    // TODO: implement initState
    super.initState();
  }

  //Blog = blog ?? // Sağladığınız kodda satır, Blog blog = Blog();sınıfın bir örneğini bildiriyor
  //Blog ve onu boş/varsayılan bir kurucuyla başlatıyor.
  //Bu örnek daha sonra API'den getirilen belirli bir blog gönderisinin ayrıntılarını yöntemde depolamak için kullanılır fetchBlogs.
  Blog blog = Blog(); //dışarıdan blog bilgisi alınacak.

  Future fetchBlogs() async {
    Uri url = Uri.parse(
        "https://tobetoapi.halitkalayci.com/api/Articles/${widget.blogId}");
    final response = await http.get(url);
    final jsonData = jsonDecode(response.body);

    setState(() {
      blog = Blog.fromJson(jsonData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 53, 46, 67),
            title: Text(blog.title == null ? "Yükleniyor" : blog.title!)),
        body: blog.id == null
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Container(
                    height: 400,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      // border: Border.all(color: Colors.green),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(40),
                      ),
                      border: Border.all(
                          color: const Color.fromARGB(255, 61, 55, 72),
                          width: 4,
                          style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        AspectRatio(
                          aspectRatio: 3 / 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(blog.thumbnail!),
                          ),
                        ),
                        Text(blog.content!),
                        Text("- ${blog.author!} -"),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
