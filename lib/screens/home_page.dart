import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mini_blog/models/blog.dart';
import 'package:mini_blog/screens/add_blog.dart';
import 'package:mini_blog/screens/blog_detail.dart';
import 'package:mini_blog/widgets/blog_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // back-end'den liste alacağım. şimdilik (anonim tipte) / modelleyene kadar
  List<Blog> blogList = []; //  <Blog> <--> <Type Safe>

// sayfa ilk açıldığında tetiklenen fonksiyon.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // http paketi ile istek atmamız lazım.
    fetchBlogs();
  }

// ------------------- METHOD -------------------

// bu verilerin tipini belirlememiz gerekir. Bunun için'de --> modelleme yaparız.
  Future fetchBlogs() async {
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles");
    final response = await http.get(url); // isteği attım.
    // json'a çevirdik. buradan blog listesi geliyor.
    final List jsonData = jsonDecode(response.body);
    // final blogJson = jsonData[0]; // sadece 0. ıncı indexini çevirdim.
    // // json'dan oku ve blog oluştur.
    // Blog blog = Blog.fromJson(blogJson);

// json'u al blog oluştur. (map tek tek verileri gezecek.) map'i ile gezin.
    // List<Blog> blogs = jsonData.map((json) => Blog.fromJson(json)).toList();
    // map tek tek geziyor ve verdiğimiz türe çeviriyor. Bu json datadaki her bir eleman için json'u al. Blog olutur.
    // nereden oluştur fromjson bilgisini vererek listeye çevir.
    /* back-End'den aldığımız liste verilerini dart'daki liste verilerine çevirdik. */
    // ************* back-End'den aldığım liste (blogList) artık Dart listesine dönüşmüş oldu. *************
    setState(() {
      blogList = jsonData.map((json) => Blog.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 45, 38, 57),
          title: const Text(
            "Blog Listesi",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            // refresh etmeden de verileri ana sayfayı getirdik.
            IconButton(
              color: Colors.white38,
              onPressed: () async {
                bool? result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AddBlog()));
                if (result == true) {
                  // demek ki ekleme işlemi gerçekleşmiş (geriye dönerken veri dönüyor.)
                  fetchBlogs();
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: blogList.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            // güncellemer için:
            : RefreshIndicator(
                onRefresh: () async {
                  fetchBlogs();
                },
                child: ListView.builder(
                  itemBuilder: (ctx, index) => GestureDetector(
                    onTap: () {
                      Navigator.of(ctx).push(MaterialPageRoute(
                        builder: (ctx) =>
                            BlogDetail(blogId: blogList[index].id!),
                      ));
                    },
                    child: BlogItem(blog: blogList[index]),
                  ),
                  // her bir blogun tıklanmasını yakalamak için kullanıldı.
                  itemCount: blogList.length,
                ),
              ));

    /* : ListView.builder(
                itemBuilder: (context, index) => Text(blogList[index].title!),
                itemCount: blogList.length,
              )); */
  }
}


/*  Kullanıcı arayüzü, verileri beklerken bir CircularProgressIndicator görüntüleyecek, bir hata olması durumunda bir hata mesajı gösterecek veya veriler mevcut olduğunda blog listesini görüntüleyecektir. */