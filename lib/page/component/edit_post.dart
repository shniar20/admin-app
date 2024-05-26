import 'package:employee/models/post_model.dart';
import 'package:employee/services/post_services.dart';
import 'package:employee/store/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPost extends StatefulWidget {
  final Post post;
  final Function refreshPage;
  const EditPost({super.key, required this.post, required this.refreshPage});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  late AdminProvider adminProvider;
  late TextEditingController postContentController;
  final PostServices postServices = PostServices();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    postContentController = TextEditingController(text: widget.post.content);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    adminProvider = Provider.of<AdminProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(14.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "گۆڕینی بڵاوکراوە",
              style: TextStyle(
                fontFamily: 'rabar',
                fontSize: 18.0,
              ),
            ),
            IconButton(
              onPressed: () async {
                if (loading) return;

                bool result = await postServices.deletePost(
                  context,
                  widget.post.id!,
                );

                if (result && context.mounted) {
                  Navigator.pop(context);
                  widget.refreshPage();
                }
              },
              visualDensity: VisualDensity.compact,
              color: Colors.grey[400],
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 180,
          child: TextField(
            controller: postContentController,
            textDirection: TextDirection.rtl,
            maxLength: 200,
            maxLines: null,
            expands: true,
            decoration: InputDecoration(
              filled: true,
              hintText: "ناوەڕۆکی بڵاوکراوە بنووسە..",
              hintStyle: TextStyle(
                fontFamily: 'rabar',
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.start,
        actionsPadding: const EdgeInsets.only(
          right: 14.0,
          bottom: 14.0,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red[700],
            ),
            child: const Text(
              "داخستن",
              style: TextStyle(
                fontFamily: 'rabar',
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (loading) return;

              setState(() {
                loading = true;
              });

              widget.post.content = postContentController.text.trim();
              bool result = await postServices.updatePost(
                context,
                widget.post,
              );

              setState(() {
                loading = false;
              });

              if (result && context.mounted) {
                Navigator.pop(context);
                widget.refreshPage();
              }
            },
            child: loading
                ? const SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(),
                  )
                : const Text(
                    "گۆڕین",
                    style: TextStyle(
                      fontFamily: 'rabar',
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
