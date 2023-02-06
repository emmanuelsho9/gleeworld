import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Book {
  final  name;
  final age;
  Book({required this.name, required this.age});
}

class BookModel with ChangeNotifier {

  Stream<List<Book>> get bookd{
    return    FirebaseFirestore.instance.collection("Books").snapshots().map((e) => e.docs.map((e) => Book(name: e.data()["name"], age: e.data()["name"])).toList());

  }

  // List<Book> _books = [];
  //
  // List<Book> get books => _books;
  //
  // void setBooks(List<Book> books) {
  //   _books = books;
  //   notifyListeners();
  // }
  // final  snjapshot = await FirebaseFirestore.instance.collection("Books").snapshots().map((event) => Book(name: event.docs.map((e) => e.data()["name"]), age: event.docs.map((e) => e.data()["name"])));

//   Future<void> fetchBooks() async {
//     List<Book> books = [];
//
// print(snjapshot);
//
//     final  snapshot = await FirebaseFirestore.instance.collection("Books").get();
//     books = snapshot.docs.map((e) {
//        //print(snapshot.docs.map((e) => e.data()["name"]));
//       return Book(name: e.data(), age: snapshot.docs.map((e) => e.data()["name"]));
//     }).toList();
//     notifyListeners();
//
//    // print(books);
//   }
}