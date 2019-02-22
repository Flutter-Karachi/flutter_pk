import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/schedule/model.dart';
import 'package:flutter_pk/widgets/full_screen_loader.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class FullScreenFeedbackDialog extends StatefulWidget {
  final Session session;
  FullScreenFeedbackDialog({this.session});
  @override
  FullScreenFeedbackDialogState createState() {
    return FullScreenFeedbackDialogState();
  }
}

class FullScreenFeedbackDialogState extends State<FullScreenFeedbackDialog> {
  double rating = 0.0;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: ColorDictionary.stringToColor[widget.session.color],
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: ColorDictionary
                            .stringToColor[widget.session.textColor],
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.rate_review,
                        size: 100.0,
                        color: ColorDictionary
                            .stringToColor[widget.session.textColor],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Text(
                          'Your feedback adds value to the quality of upcoming events!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: ColorDictionary
                                .stringToColor[widget.session.textColor],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Rate this session',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: ColorDictionary
                                .stringToColor[widget.session.textColor],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: ColorDictionary
                                  .stringToColor[widget.session.textColor],
                              borderRadius: BorderRadius.circular(10.0)),
                          child: ListTile(
                            title: Center(
                              child: Text(
                                widget.session.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorDictionary
                                      .stringToColor[widget.session.color],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SmoothStarRating(
                        allowHalfRating: true,
                        onRatingChanged: (value) {
                          setState(() {
                            rating = value;
                          });
                        },
                        starCount: 5,
                        rating: rating,
                        size: 40.0,
                        color: ColorDictionary
                            .stringToColor[widget.session.textColor],
                        borderColor: ColorDictionary
                            .stringToColor[widget.session.textColor],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'CONTINUE',
                                  style: TextStyle(
                                    color: ColorDictionary.stringToColor[
                                        widget.session.textColor],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 24.0,
                                  color: ColorDictionary
                                      .stringToColor[widget.session.textColor],
                                )
                              ],
                            ),
                            textColor: Theme.of(context).primaryColor,
                            onPressed: _submitFeedback,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          _isLoading ? FullScreenLoader() : Container()
        ],
      ),
    );
  }

  void _submitFeedback() async {
    setState(() => _isLoading = true);
    try {
      CollectionReference reference =
          Firestore.instance.collection(FireStoreKeys.userCollection);
      await reference.document(userCache.user.id).setData(
        {
          'feedback': {widget.session.id: rating}
        },
        merge: true,
      );
      Alert(
        context: context,
        type: AlertType.success,
        title: "Thank you!",
        desc: "Your feedback has been recorded",
        buttons: [
          DialogButton(
            child: Text("Cool!",
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.white,
                    )),
            color: ColorDictionary.stringToColor[widget.session.color],
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil(
                ModalRoute.withName(Routes.home_master),
              );
            },
          )
        ],
      ).show();
    } catch (ex) {
      print(ex);
      Alert(
        context: context,
        type: AlertType.error,
        title: "Oops!",
        desc: "An error has occurred",
        buttons: [
          DialogButton(
            child: Text("Dismiss",
                style: Theme.of(context).textTheme.title.copyWith(
                      color: Colors.white,
                    )),
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ).show();
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
