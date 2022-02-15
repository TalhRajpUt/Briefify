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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback? deletePost;
  final VoidCallback playAudio;
  final bool isMyPost;

  const PostCard(
      {Key? key,
      required this.post,
      required this.playAudio,
      this.deletePost,
      this.isMyPost = false})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  var result1;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _userData = Provider.of<UserProvider>(context, listen: false);
    final myUser = _userData.user;
    final int userId = myUser.id as int;
    final int postId = widget.post.id as int;
    final String heading = widget.post.heading as String;
    final String summary = widget.post.summary as String;
    final String videolink = widget.post.videoLink as String;
    final String ariclelink = widget.post.articleLink as String;
    var category = widget.post.category;

    var myJSON = jsonDecode(widget.post.summary);
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        showBadge: widget.post.user.badgeStatus == 2,
                        position: BadgePosition.bottomEnd(bottom: 0, end: -5),
                        badgeColor: kPrimaryColorLight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(200),
                          child: FadeInImage(
                            placeholder: const AssetImage(userAvatar),
                            image: NetworkImage(widget.post.user.image),
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
                                context,
                                myUser.id == widget.post.user.id
                                    ? myProfileRoute
                                    : showUserRoute,
                                arguments: {'user': widget.post.user});
                          },
                          child: Text(
                            widget.post.user.name,
                            maxLines: 1,
                            style: const TextStyle(
                              color: kPrimaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          widget.post.timeStamp,
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
                myUser.id == widget.post.user.id
                    ? Container()
                    : PopupMenuButton(
                        icon: const Icon(
                          FontAwesomeIcons.ellipsisV,
                          size: 16,
                          color: Colors.blue,
                        ),
                        onSelected: (newValue) {
                          // add this property
                          setState(() {
                            result1 =
                                newValue;
                            if (result1 == 0) {
                              Navigator.pushNamed(context, reportUserRoute);
                            }
                            if (result1 == 1) {
                              Navigator.pushNamed(context, reportUserRoute);
                            }
                            // it gives the value which is selected
                          });
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          const PopupMenuItem(
                            value: 0,
                            child: Text('Block User'),
                          ),
                          const PopupMenuItem(
                            value: 1,
                            child: Text('Report'),
                          ),
                        ],
                      ),
                // GestureDetector(
                //   onTap: (){
                //   },
                //   child: const Icon(
                //     FontAwesomeIcons.ellipsisV,
                //     size: 16,
                //     color: Colors.blue,
                //   ),
                // ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                widget.post.heading,
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
                        _launchURL(widget.post.articleLink);
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
                widget.post.videoLink.isNotEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: MaterialButton(
                            onPressed: () {
                              _launchURL1(widget.post.videoLink, context);
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
                  child: widget.post.pdf.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: MaterialButton(
                            onPressed: () {
                              _launchURL(widget.post.pdf);
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
                if (widget.post.videoLink.isEmpty) Expanded(child: Container())
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.post.userLike) {
                        widget.post.likes--;
                        widget.post.userLike = false;
                        NetworkHelper().unlikePost(widget.post.id.toString());
                      } else {
                        widget.post.likes++;
                        widget.post.userLike = true;
                        NetworkHelper().likePost(widget.post.id.toString());
                        if (widget.post.userDislike) {
                          widget.post.userDislike = false;
                          widget.post.dislikes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: Icon(
                      Icons.favorite,
                      color: widget.post.userLike
                          ? Colors.red
                          : kSecondaryTextColor,
                      size: 17,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.post.userLike) {
                        widget.post.likes--;
                        widget.post.userLike = false;
                        NetworkHelper().unlikePost(widget.post.id.toString());
                      } else {
                        widget.post.likes++;
                        widget.post.userLike = true;
                        NetworkHelper().likePost(widget.post.id.toString());
                        if (widget.post.userDislike) {
                          widget.post.userDislike = false;
                          widget.post.dislikes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: const SizedBox(
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.post.userLike) {
                        widget.post.likes--;
                        widget.post.userLike = false;
                        NetworkHelper().unlikePost(widget.post.id.toString());
                      } else {
                        widget.post.likes++;
                        widget.post.userLike = true;
                        NetworkHelper().likePost(widget.post.id.toString());
                        if (widget.post.userDislike) {
                          widget.post.userDislike = false;
                          widget.post.dislikes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: Text(
                      widget.post.likes.toString(),
                      style: const TextStyle(color: kSecondaryTextColor),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (widget.post.userDislike) {
                        widget.post.dislikes--;
                        widget.post.userDislike = false;
                        NetworkHelper()
                            .unDislikePost(widget.post.id.toString());
                      } else {
                        widget.post.dislikes++;
                        widget.post.userDislike = true;
                        NetworkHelper().dislikePost(widget.post.id.toString());
                        if (widget.post.userLike) {
                          widget.post.userLike = false;
                          widget.post.likes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: Icon(
                      Icons.thumb_down,
                      color: widget.post.userDislike
                          ? Colors.red
                          : kSecondaryTextColor,
                      size: 17,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (widget.post.userDislike) {
                        widget.post.dislikes--;
                        widget.post.userDislike = false;
                        NetworkHelper()
                            .unDislikePost(widget.post.id.toString());
                      } else {
                        widget.post.dislikes++;
                        widget.post.userDislike = true;
                        NetworkHelper().dislikePost(widget.post.id.toString());
                        if (widget.post.userLike) {
                          widget.post.userLike = false;
                          widget.post.likes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: const SizedBox(
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (widget.post.userDislike) {
                        widget.post.dislikes--;
                        widget.post.userDislike = false;
                        NetworkHelper()
                            .unDislikePost(widget.post.id.toString());
                      } else {
                        widget.post.dislikes++;
                        widget.post.userDislike = true;
                        NetworkHelper().dislikePost(widget.post.id.toString());
                        if (widget.post.userLike) {
                          widget.post.userLike = false;
                          widget.post.likes--;
                        }
                      }
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: Text(
                      widget.post.dislikes.toString(),
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
                      await Navigator.pushNamed(context, commentsRoute,
                          arguments: {'post': widget.post});
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
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
                      await Navigator.pushNamed(context, commentsRoute,
                          arguments: {'post': widget.post});
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: const SizedBox(
                      width: 10,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.pushNamed(context, commentsRoute,
                          arguments: {'post': widget.post});
                      final _postsData = Provider.of<HomePostsProvider>(context,
                          listen: false);
                      _postsData.updateChanges();
                    },
                    child: Text(
                      widget.post.commentsCount.toString(),
                      style: const TextStyle(
                        color: kSecondaryTextColor,
                      ),
                    ),
                  ),
                  if (widget.isMyPost)
                    const SizedBox(
                      width: 20,
                    ),
                  if (widget.isMyPost)
                    GestureDetector(
                      onTap: () async {
                        widget.deletePost!();
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        color: kSecondaryTextColor,
                        size: 17,
                      ),
                    ),
                  if (widget.isMyPost)
                    const SizedBox(
                      width: 10,
                    ),
                  if (widget.isMyPost)
                    GestureDetector(
                      onTap: () async {
                        widget.deletePost!();
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
                      widget.playAudio();
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
                  myUser.id == widget.post.user.id
                      ? GestureDetector(
                          onTap: () async {
                            Navigator.pushNamed(context, editPostRoute,
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
                        )
                      : Container(),
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
    Navigator.pushNamed(context, ytScreen, arguments: RouteArgument(url: url));
  }
}
