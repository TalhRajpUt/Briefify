import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:briefify/data/constants.dart';
import 'package:briefify/data/image_paths.dart';
import 'package:briefify/data/routes.dart';
import 'package:briefify/helpers/network_helper.dart';
import 'package:briefify/models/edit_post_argument.dart';
import 'package:briefify/models/post_model.dart';
import 'package:briefify/models/route_argument.dart';
import 'package:briefify/providers/home_posts_provider.dart';
import 'package:briefify/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quil;
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final VoidCallback? deletePost;
  final VoidCallback playAudio;
  final bool isMyPost;
  const PostCard(
      {Key? key, required this.post, required this.playAudio, this.deletePost, this.isMyPost = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {

    // Send Data with Navigator.push

    String name = 'usman shoaib';
    int age;

    // Send Data with Navigator.push

    final _userData = Provider.of<UserProvider>(context, listen: false);
    final myUser = _userData.user;
    final int userId = myUser.id as int;
    final int postId = post.id as int;
    final String heading = post.heading as String;
    final String summary = post.summary as String;
    final String videolink = post.videoLink as String;
    final String ariclelink = post.articleLink as String;
    var category = post.category;

    var myJSON = jsonDecode(post.summary);
    final quil.QuillController _summaryController = quil.QuillController(
      document: quil.Document.fromJson(myJSON),
      selection: const TextSelection.collapsed(offset: 0),
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15, 10, 15),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            color: kTextColorLightGrey,
            width: 0.7,
          ))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // final _userData = Provider.of<UserProvider>(context, listen: false);
                    // final myUser = _userData.user;
                    // Navigator.pushNamed(context, myUser.id == post.user.id ? myProfileRoute : showUserRoute,
                    //     arguments: {'user': post.user});
                  },
                  child: Badge(
                    badgeContent: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 10,
                    ),
                    showBadge: post.user.badgeStatus == 2,
                    position: BadgePosition.bottomEnd(bottom: 0, end: -5),
                    badgeColor: kPrimaryColorLight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200),
                      child: FadeInImage(
                        placeholder: const AssetImage(userAvatar),
                        image: NetworkImage(post.user.image),
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, object, trace) {
                          return Image.asset(
                            appLogo,
                            height: 45,
                            width: 45,
                          );
                        },
                        height: 45,
                        width: 45,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                            context, myUser.id == post.user.id ? myProfileRoute : showUserRoute,
                            arguments: {'user': post.user});
                      },
                      child: Text(
                        post.user.name,
                        maxLines: 1,
                        style: const TextStyle(
                          color: kPrimaryTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      post.timeStamp,
                      maxLines: 1,
                      style: const TextStyle(
                        color: kSecondaryTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                post.heading,
                maxLines: 1,
                style: const TextStyle(
                  color: kPrimaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 150,
              ),
              child: quil.QuillEditor.basic(
                controller: _summaryController,
                readOnly: true,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: MaterialButton(
                      onPressed: () {
                        _launchURL(post.articleLink);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            Icons.article,
                            color: Colors.white,
                            size: 16,
                          ),
                          Text(
                            'Article',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                      color: kSecondaryColorDark,
                    ),
                  ),
                ),
                post.videoLink.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: MaterialButton(
                            onPressed: () {
                              _launchURL1(post.videoLink, context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                Text(
                                  'Watch',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            color: kSecondaryColorDark,
                          ),
                        ),
                      )
                    : Container(),
                Expanded(
                  child: post.pdf.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: MaterialButton(
                            onPressed: () {
                              _launchURL(post.pdf);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(
                                  Icons.article,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                Text(
                                  'PDF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            color: kSecondaryColorDark,
                          ),
                        )
                      : Container(),
                ),
                if (post.videoLink.isEmpty) Expanded(child: Container())
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (post.userLike) {
                        post.likes--;
                        post.userLike = false;
                        NetworkHelper().unlikePost(post.id.toString());
                      } else {
                        post.likes++;
                        post.userLike = true;
                        NetworkHelper().likePost(post.id.toString());
                        if (post.userDislike) {
                          post.userDislike = false;
                          post.dislikes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context, listen: false);
                      _postsData.updateChanges();
                    },
                    child: Icon(
                      Icons.favorite,
                      color: post.userLike ? Colors.red : kSecondaryTextColor,
                      size: 17,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (post.userLike) {
                        post.likes--;
                        post.userLike = false;
                        NetworkHelper().unlikePost(post.id.toString());
                      } else {
                        post.likes++;
                        post.userLike = true;
                        NetworkHelper().likePost(post.id.toString());
                        if (post.userDislike) {
                          post.userDislike = false;
                          post.dislikes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context, listen: false);
                      _postsData.updateChanges();
                    },
                    child: const SizedBox(
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (post.userLike) {
                        post.likes--;
                        post.userLike = false;
                        NetworkHelper().unlikePost(post.id.toString());
                      } else {
                        post.likes++;
                        post.userLike = true;
                        NetworkHelper().likePost(post.id.toString());
                        if (post.userDislike) {
                          post.userDislike = false;
                          post.dislikes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context, listen: false);
                      _postsData.updateChanges();
                    },
                    child: Text(
                      post.likes.toString(),
                      style: const TextStyle(color: kSecondaryTextColor),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (post.userDislike) {
                        post.dislikes--;
                        post.userDislike = false;
                        NetworkHelper().unDislikePost(post.id.toString());
                      } else {
                        post.dislikes++;
                        post.userDislike = true;
                        NetworkHelper().dislikePost(post.id.toString());
                        if (post.userLike) {
                          post.userLike = false;
                          post.likes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context, listen: false);
                      _postsData.updateChanges();
                    },
                    child: Icon(
                      Icons.thumb_down,
                      color: post.userDislike ? Colors.red : kSecondaryTextColor,
                      size: 17,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (post.userDislike) {
                        post.dislikes--;
                        post.userDislike = false;
                        NetworkHelper().unDislikePost(post.id.toString());
                      } else {
                        post.dislikes++;
                        post.userDislike = true;
                        NetworkHelper().dislikePost(post.id.toString());
                        if (post.userLike) {
                          post.userLike = false;
                          post.likes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context, listen: false);
                      _postsData.updateChanges();
                    },
                    child: const SizedBox(
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (post.userDislike) {
                        post.dislikes--;
                        post.userDislike = false;
                        NetworkHelper().unDislikePost(post.id.toString());
                      } else {
                        post.dislikes++;
                        post.userDislike = true;
                        NetworkHelper().dislikePost(post.id.toString());
                        if (post.userLike) {
                          post.userLike = false;
                          post.likes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context, listen: false);
                      _postsData.updateChanges();
                    },
                    child: Text(
                      post.dislikes.toString(),
                      style: const TextStyle(
                        color: kSecondaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, commentsRoute, arguments: {'post': post});
                      final _postsData = Provider.of<HomePostsProvider>(context, listen: false);
                      _postsData.updateChanges();
                    },
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      color: kSecondaryTextColor,
                      size: 17,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, commentsRoute, arguments: {'post': post});
                      final _postsData = Provider.of<HomePostsProvider>(context, listen: false);
                      _postsData.updateChanges();
                    },
                    child: const SizedBox(
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, commentsRoute, arguments: {'post': post});
                      final _postsData = Provider.of<HomePostsProvider>(context, listen: false);
                      _postsData.updateChanges();
                    },
                    child: Text(
                      post.commentsCount.toString(),
                      style: const TextStyle(
                        color: kSecondaryTextColor,
                      ),
                    ),
                  ),
                  if (isMyPost)
                    const SizedBox(
                      width: 20,
                    ),
                  if (isMyPost)
                    GestureDetector(
                      onTap: () async {
                        deletePost!();
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        color: kSecondaryTextColor,
                        size: 17,
                      ),
                    ),
                  if (isMyPost)
                    const SizedBox(
                      width: 10,
                    ),
                  if (isMyPost)
                    GestureDetector(
                      onTap: () async {
                        deletePost!();
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: kSecondaryTextColor,
                        ),
                      ),
                    ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Share.share(quil.Document.fromJson(myJSON).toPlainText());
                    },
                    child: const Icon(
                      Icons.share,
                      color: kSecondaryTextColor,
                      size: 19,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      playAudio();
                    },
                    child: const Icon(
                      Icons.volume_up,
                      color: kSecondaryTextColor,
                      size: 19,
                    ),
                  ),

                  const SizedBox(
                    width: 20,
                  ),

                  myUser.id == post.user.id?
                  GestureDetector(
                    onTap: () async {
                      print('From here we navigate after printing values 1');
                      print(category);
                      print('From here we navigate after printing values 2');
                      Navigator.pushNamed(
                          context, editPostRoute,
                          arguments: EditPostArgument(
                            userId: userId,
                            postId: postId,
                            heading: heading,
                            summary: summary,
                            videolink: videolink,
                            ariclelink: ariclelink,
                            // category: category,
                          ));
                    },
                    child: const Icon(
                      Icons.edit,
                      color: kSecondaryTextColor,
                      size: 19,
                    ),
                  ):
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (!await launch(url)) throw 'Could not launch $url';
    print("abcd");

  }
  void _launchURL1(String url, BuildContext context) async {
    print("123");
    Navigator.pushNamed(
        context, ytScreen,
        arguments: RouteArgument(url: url));
  }
}
