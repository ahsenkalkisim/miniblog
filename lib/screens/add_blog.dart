import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// blog ekleme kısmı

class AddBlog extends StatefulWidget {
  const AddBlog({Key? key}) : super(key: key);

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  // imagePicker nesnesi oluşturdum.
  final ImagePicker imagePicker = ImagePicker();
  XFile? selectedImage;
  // Formu'muzun state'ni tutucak. (gönderildi mi? valid mi? hatalı alan var mı ?)
  // Formlar'da controller - fields ilişkisi gibi.
  final _formKey = GlobalKey<FormState>();
  // bu bilgileri tutacağım.
  String title = " ";
  String content = " ";
  String author = " ";

  // save metodun'dan sonra:
  Future submit() async {
    // Submit fonksiyonu'nun Kodlanması..
    // Burada bir request hazırlayacağız.
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles");

    var request = http.MultipartRequest("POST", url);
    request.fields['Title'] = title;
    request.fields['Content'] = content;
    request.fields['Author'] = author;

    // seçilmiş dosyayı eklemek için'de:
    if (selectedImage != null) {
      final file =
          await http.MultipartFile.fromPath("File", selectedImage!.path);
      request.files.add(file);
    }
    // requestim hazır: ve gönderiyorum.
    final response = await request.send();

    if (response.statusCode == 201) {
      // Ekleme Başarılı
      // pop fonksiyonu'nun 2. opsiyonel bir parametresi var. <T>
      // Navigator.pop(context.);
      Navigator.pop(
          context, true); // true ile --> (geriye dönerken veri dönüyor.)
    }
  }

// resmi almak için method oluşturdum.
  Future pickImage() async {
    XFile? selectedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = selectedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Yeni Blog Ekle"),
        ),
        // ************** Form Yönetimi **************
        // save / validaiton
        // formları (key) alanı üzerinden yönetiriz.
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            // responsive adına ListView() kullandık.
            child: ListView(
              // Image_picker => görsel seçimi:::
              children: [
                if (selectedImage != null)
                  Image.file(File(selectedImage!.path)),
                // Image_picker => görsel seçimi:::
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.black),
                    onPressed: () {
                      pickImage();
                    },
                    child: const Text(
                      "Fotoğraf seç",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                // Image_picker => görsel seçimi:::
                // TextFormField 'in TextField'dan farkı --> onsaved ve validator alıyor olmasıdır.
                TextFormField(
                  onSaved: (newValue) {
                    title = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "lütfen bir blog başlığı giriniz";
                    }

                    return null;
                  },
                  decoration:
                      const InputDecoration(label: Text("Blog Başlığı")),
                ), // title
                TextFormField(
                  onSaved: (newValue) {
                    content = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "lütfen bir blog içeriği giriniz";
                    }

                    return null;
                  },
                  decoration:
                      const InputDecoration(label: Text("Blog İçeriği")),
                  maxLines: 5,
                ), // content
                TextFormField(
                  onSaved: (newValue) {
                    author = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "lütfen bir ad soyad giriniz";
                    }

                    return null;
                  },
                  decoration: const InputDecoration(label: Text("Ad Soyad")),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.black),
                      onPressed: () {
                        // form'u göndermek yada göndermemek.
                        if (_formKey.currentState!.validate()) {
                          // formun valid olduğu durumu kontrol etmiş oluyorum.
                          // işte valid ise backend'e isteği gönderecek
                          // değilse göndermeyecek çünkü hata var.
                          // eğer valid ise bu formu save et.
                          _formKey.currentState!.save();
                          // kaydet ve gönder...
                          submit();
                        }
                      },
                      child: const Text(
                        "Blog ekle",
                        style: TextStyle(color: Colors.white),
                      )),
                ), // Author
              ],
            ),
          ),
        ));
  }
}
