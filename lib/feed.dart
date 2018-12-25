import 'package:flutter/material.dart';
import 'package:flutter_pk/widgets/custom_app_bar.dart';

class FeedPage extends StatefulWidget {
  @override
  FeedPageState createState() {
    return new FeedPageState();
  }
}

class FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: 'Feeds',
            ),
            _buildBody()
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              child: Image(
                image: AssetImage('assets/loader.png'),
              ),
              height: 70.0,
              width: 70.0,
            ),
            Center(
              child: Text(
                'You will see some cool tweets here, soon!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.black38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
