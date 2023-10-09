import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'translate.dart';

class Rating extends StatefulWidget {
  Map data = {};
   Rating({super.key,required this.data});

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        textToTrans(
          input: 'Rate this app:',
          style: TextStyle(fontSize: 18),
        ),
        RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 40,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
            print("-------$_rating--");
          },
        ),
        textToTrans(input: "$_rating star"),
        SizedBox(height: 20),
        TextField(
          controller: _feedbackController,
          decoration: InputDecoration(
            hintText: 'Enter your feedback...',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            launchUrl(Uri.parse("${widget.data['rating_url']}"),mode: LaunchMode.inAppWebView);
          },
          child: textToTrans(input: 'Submit'),
        ),
      ],
    );
  }
}
