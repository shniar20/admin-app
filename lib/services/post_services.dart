import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee/models/post_model.dart';
import 'package:employee/utils/snackbar.dart';
import 'package:flutter/material.dart';

class PostServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Post>> getPosts(int department) async {
    List<Post> posts = [];
    QuerySnapshot documents = await _firebaseFirestore
        .collection("posts")
        .where("department", isEqualTo: department)
        .orderBy("postedAt", descending: true)
        .get();

    for (var document in documents.docs) {
      Post post = Post.fromMap(document.data() as Map<String, dynamic>);
      post.id = document.id;
      posts.add(post);
    }

    return posts;
  }

  Future<bool> addPost(BuildContext context, Post post) async {
    try {
      await _firebaseFirestore.collection("posts").add(post.toMap());

      return true;
    } on FirebaseException catch (err) {
      if (context.mounted) {
        showSnackBar(context, err.message.toString());
      }
      return false;
    }
  }

  Future<bool> updatePost(BuildContext context, Post post) async {
    try {
      await _firebaseFirestore
          .collection("posts")
          .doc(post.id!)
          .set(post.toMap());

      return true;
    } on FirebaseException catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.message.toString());
      }
      return false;
    }
  }

  Future<bool> deletePost(BuildContext context, String id) async {
    try {
      await _firebaseFirestore.collection("posts").doc(id).delete();

      return true;
    } on FirebaseException catch (error) {
      if (context.mounted) {
        showSnackBar(context, error.message.toString());
      }
      return false;
    }
  }
}
