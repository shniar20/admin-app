import 'package:employee/models/post_model.dart';
import 'package:employee/services/post_services.dart';
import 'package:employee/store/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  final Function refreshPage;
  const AddPost({super.key, required this.refreshPage});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  late AdminProvider adminProvider;
  final TextEditingController postContentController = TextEditingController();
  final PostServices postServices = PostServices();
  bool loading = false;

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
        title: const Text(
          "بڵاوکردنەوە",
          style: TextStyle(
            fontFamily: 'rabar',
            fontSize: 18.0,
          ),
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
              bool result = await postServices.addPost(
                context,
                Post(
                  content: postContentController.text.trim(),
                  department: adminProvider.facility!.department,
                ),
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
                    "بڵاوکردنەوە",
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
