import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/home_master.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pk/widgets/full_screen_loader.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sprung/sprung.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Pakistan'),
      routes: {
        Routes.home_master: (context) => new HomePageMaster(),
        Routes.main: (context) => MyHomePage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  bool _showSwipeText = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: _buildBody(context),
        ),
        _isLoading ? FullScreenLoader() : Container()
      ],
    );
  }

  SafeArea _buildBody(BuildContext context) {
    return SafeArea(
      child: new Swiper.children(
        autoplay: false,
        loop: false,
        pagination: new SwiperPagination(
          margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
          builder: new DotSwiperPaginationBuilder(
              color: Colors.black26,
              activeColor: Colors.blue,
              size: 10.0,
              activeSize: 15.0),
        ),
        children: <Widget>[
          _buildFirstSwiperControlPage(context),
          _buildSecondSwiperControlPage(context),
        ],
      ),
    );
  }

  Center _buildSecondSwiperControlPage(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SizedBox(
            height: 250.0,
            width: 250.0,
            child: _isLoading
                ? Container()
                : Image(
                    image: AssetImage('assets/loader.png'),
                  ),
          ),
          Column(
            children: <Widget>[
              Text(
                'Register | Attend | Build',
                style: Theme.of(context).textTheme.title,
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
                child: Text(
                  'Get information about events, their agendas and register yourself as an attendee',
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: RaisedButton(
                  onPressed: _handleSignIn,
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  child: Text('Get started'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Center _buildFirstSwiperControlPage(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          SprungBox(
            damped: Damped.critically,
            callback: (bool value) {
              setState(() => _showSwipeText = value);
            },
          ),
          Column(
            children: <Widget>[
              Text(
                'Welcome to Flutter Pakistan',
                style: Theme.of(context).textTheme.title,
              ),
              AnimatedCrossFade(
                crossFadeState: _showSwipeText
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: Duration(milliseconds: 800),
                firstChild: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Text('Swipe left to proceed'),
                ),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Text(
                    'Swipe right to proceed',
                    style: TextStyle(color: Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _handleSignIn() async {
    setState(() => _isLoading = true);
    try {
      GoogleSignInAccount googleUser = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      FirebaseUser user = await auth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await userCache.getCurrentUser();
      Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.home_master,
        ModalRoute.withName(Routes.main),
      );
    } catch (ex) {
      print(ex);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

typedef void BoolCallback(bool val);

class SprungBox extends StatefulWidget {
  final Damped damped;
  final Duration duration;
  final BoolCallback callback;

  SprungBox({
    this.damped = Damped.critically,
    this.callback,
    duration,
  }) : this.duration = duration ?? Duration(milliseconds: 3500);

  @override
  _SprungBoxState createState() => _SprungBoxState();
}

class _SprungBoxState extends State<SprungBox>
    with SingleTickerProviderStateMixin {
  bool _isOffset = false;
  bool showFlag = false;

  @override
  void initState() {
    super.initState();
    _toggleOffset();
  }

  void _toggleOffset() async {
    await Future.delayed(new Duration(milliseconds: 500));
    setState(() {
      this._isOffset = !this._isOffset;
    });
    await Future.delayed(new Duration(milliseconds: 1500));
    widget.callback(true);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxWidth * 2;
        final left = !this._isOffset ? height + 100.0 : 40.0;

        final width = MediaQuery.of(context).size.width * 2;

        return Padding(
          padding: const EdgeInsets.only(right: 48.0),
          child: AnimatedContainer(
            duration: this.widget.duration,
            curve: Sprung(damped: this.widget.damped),
            margin: EdgeInsets.only(
              left: left,
            ),
            height: 250.0,
            width: width,
            color: Colors.transparent,
            child: SizedBox(
              height: 250.0,
              width: 250.0,
              child: Image(
                image: AssetImage('assets/flutterKarachi.png'),
              ),
            ),
          ),
        );
      },
    );
  }
}
