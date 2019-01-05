import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pk/caches/user.dart';
import 'package:flutter_pk/contribution/contribution_dialog.dart';
import 'package:flutter_pk/dialogs/custom_error_dialog.dart';
import 'package:flutter_pk/global.dart';
import 'package:flutter_pk/home_master.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pk/widgets/full_screen_loader.dart';
import 'package:flutter_pk/widgets/sprung_box.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isFetchingSharedPreferences = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return _isFetchingSharedPreferences
        ? Scaffold(
            body: Center(),
          )
        : Stack(
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
                padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
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

      CollectionReference reference =
          Firestore.instance.collection(FireStoreKeys.userCollection);

      if(reference.document(user.uid).get() == null) {
        User _user = User(
            name: user.displayName,
            mobileNumber: user.phoneNumber,
            id: user.uid,
            photoUrl: user.photoUrl,
            email: user.email);

        reference.document(user.uid).setData(_user.toJson());
      }
      final SharedPreferences prefs = await sharedPreferences;
      prefs.setString(SharedPreferencesKeys.firebaseUserId, user.uid);

      await userCache.getCurrentUser(user.uid);

      if(!userCache.user.isContributor) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenContributionDialog(),
            fullscreenDialog: true,
          ),
        );
      }

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

  void _getSharedPreferences() async {
    setState(() => _isFetchingSharedPreferences = true);
    try {
      final SharedPreferences prefs = await sharedPreferences;
      var userId = prefs.get(SharedPreferencesKeys.firebaseUserId);
      if (userId != null) {
        await userCache.getCurrentUser(userId);
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.home_master,
          ModalRoute.withName(Routes.main),
        );
      }
    } catch (ex) {
      print(ex);
      showErrorDialog('Oops!', 'An error has occured', context);
    } finally {
      setState(() => _isFetchingSharedPreferences = false);
    }
  }
}
