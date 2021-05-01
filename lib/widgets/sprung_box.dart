import 'package:flutter/material.dart';
import 'package:sprung/sprung.dart';

typedef void BoolCallback(bool val);

class SprungBox extends StatefulWidget {
  final Duration duration;
  final BoolCallback? callback;

  SprungBox({
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
    await Future.delayed(
      new Duration(milliseconds: 500),
      () => setState(() {
            this._isOffset = !this._isOffset;
          }),
    );
    await Future.delayed(
      new Duration(milliseconds: 1500),
      () => widget.callback!(true),
    );
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
            curve: Sprung(),
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
