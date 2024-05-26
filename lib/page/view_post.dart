import 'package:employee/models/post_model.dart';
import 'package:employee/page/component/add_post.dart';
import 'package:employee/page/component/edit_post.dart';
import 'package:employee/services/post_services.dart';
import 'package:employee/store/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:employee/page/component/side_drawer.dart';
import 'package:provider/provider.dart';

class ViewPost extends StatefulWidget {
  const ViewPost({Key? key}) : super(key: key);

  @override
  State<ViewPost> createState() => PostState();
}

class PostState extends State<ViewPost> {
  late AdminProvider adminProvider;
  final PostServices postServices = PostServices();
  List<Post> posts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    adminProvider = Provider.of<AdminProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    postServices.getPosts(adminProvider.facility!.department).then((value) {
      setState(() {
        posts = value;
        loading = false;
      });
    });
  }

  Future refresh() async {
    setState(() {
      loading = true;
    });
    posts = await postServices.getPosts(adminProvider.facility!.department);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.add,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AddPost(
                    refreshPage: refresh,
                  );
                });
          },
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 110, 14, 7),
        title: const Text(
          "بڵاوکراوەکان",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'rabar',
          ),
        ),
        centerTitle: true,
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      endDrawer: const SideDrawer(),
      // body: GridView.count(
      //   crossAxisCount: 1,
      //   crossAxisSpacing: 16.0,
      //   mainAxisSpacing: 16.0,
      //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
      //   children: [
      //     _buildCategoryCard(
      //         'ئاگر کوژێنەوە',
      //         Icons.local_fire_department,
      //         Colors.red,
      //         '  هەموو ماڵێک پێويستە شەوان ئاگارداری گەرمکەرەوەکانيان بن لە کاتی نوستن'),
      //     _buildCategoryCard('هاتوچۆ', Icons.local_police, Colors.green,
      //         'ێگای بەختياری ئەمڕۆ داخراوە'),
      //     _buildCategoryCard('ئەمبولانس', Icons.local_hospital, Colors.blue,
      //         'تکايە ئاگاداری تەندروستيتان بن'),
      //     _buildCategoryCard(
      //         'ئاگر کوژێنەوە',
      //         Icons.local_fire_department,
      //         Colors.red,
      //         'هەموو ماڵێک پێويستە شەوان ئاگارداری گەرمکەرەوەکانيان بن لە کاتی نوستن'),
      //     _buildCategoryCard('هاتوچۆ', Icons.local_police, Colors.green,
      //         'ێگای بەختياری ئەمڕۆ داخراوە'),
      //   ],
      // ),
      body: loading
          ? const Center(
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await refresh();
              },
              child: posts.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.all(10.0),
                      itemBuilder: (context, index) {
                        late String title;
                        late IconData icon;
                        late Color color;
                        switch (posts[index].department) {
                          case 0:
                            title = "ئەمبوڵانس";
                            icon = Icons.local_hospital;
                            color = Colors.blue;
                            break;
                          case 1:
                            title = "ئاگر کوژێنەوە";
                            icon = Icons.local_fire_department;
                            color = Colors.red;
                            break;
                          case 2:
                            title = "هاتوچۆ";
                            icon = Icons.local_police;
                            color = Colors.green;
                            break;
                        }

                        return _buildCategoryCard(
                            title, icon, color, posts[index]);
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10.0),
                      itemCount: posts.length,
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) => ListView(
                        children: [
                          Expanded(
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Center(
                                child: Text(
                                  "هیچ پۆستێک نییە",
                                  style: TextStyle(
                                    fontFamily: 'rabar',
                                    fontSize: 24.0,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
    );
  }

  Widget _buildCategoryCard(
      String title, IconData icon, Color color, Post post) {
    return Card(
      child: Stack(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'rabar',
                      color: Color.fromARGB(255, 110, 14, 7)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30.0),
                Text(
                  post.content,
                  style: const TextStyle(
                      fontSize: 19.0, color: Color.fromARGB(255, 62, 62, 62)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30.0),
                Icon(
                  icon,
                  color: color,
                  size: 35.0,
                ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            left: 10,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => EditPost(
                    post: post,
                    refreshPage: refresh,
                  ),
                );
              },
              visualDensity: VisualDensity.compact,
              color: Colors.grey[400],
              icon: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}
