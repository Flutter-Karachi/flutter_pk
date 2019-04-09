import 'package:flutter/material.dart';
import 'package:flutter_pk/helpers/formatters.dart';
import 'package:flutter_pk/schedule/model.dart';
import 'package:flutter_pk/schedule/session_detail.dart';
import 'package:flutter_pk/theme.dart';
import 'package:flutter_pk/widgets/custom_app_bar.dart';
import 'package:progress_indicators/progress_indicators.dart';

class SchedulePage extends StatefulWidget {
  @override
  SchedulePageState createState() {
    return new SchedulePageState();
  }
}

class SchedulePageState extends State<SchedulePage>
    with SingleTickerProviderStateMixin {

  ScheduleApi api = ScheduleApi();
  List<Session> _sessions = List<Session>();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: 'Schedule',
            ),
            _buildBody()
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: _isLoading
          ? Center(
              child: HeartbeatProgressIndicator(
                child: SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: Image(image: AssetImage('assets/loader.png')),
                ),
              ),
            )
          : _buildList(),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: _sessions.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItem(context, _sessions[index]);
      },
      padding: const EdgeInsets.only(top: 20.0),
    );
  }

  Widget _buildListItem(BuildContext context, Session session) {
    var hour = session.startDateTime?.hour;
    var minute = session.startDateTime?.minute;

    if (hour == null || minute == null)
      return Center(
        child: Text(
          'Nothing found!',
          style: Theme.of(context).textTheme.title.copyWith(
                color: Colors.black26,
                fontWeight: FontWeight.bold,
              ),
        ),
      );

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                children: <Widget>[
                  Text(
                    '${_formatTimeDigit(hour)}:${_formatTimeDigit(minute)}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'HRS',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorDictionary.stringToColor[session?.color],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                child: ListTile(
                    title: Text(
                      session.title,
                      style: TextStyle(
                          color: ColorDictionary
                              .stringToColor[session?.textColor]),
                    ),
                    subtitle: Text(
                      '${formatDate(
                        session?.startDateTime,
                        DateFormats.shortUiDateTimeFormat,
                      )} - ${formatDate(
                        session?.endDateTime,
                        DateFormats.shortUiTimeFormat,
                      )}',
                      style: TextStyle(
                        color:
                            ColorDictionary.stringToColor[session?.textColor],
                      ),
                    ),
                    onTap: () => _handleListTileOnTap(session, context)),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
        ),
      ],
    );
  }

  String _formatTimeDigit(int timeValue) =>
      timeValue < 10 ? '0' + timeValue.toString() : timeValue.toString();

  Future _handleListTileOnTap(Session session, BuildContext context) async {
    var isDescriptionAvailable =
        session.description != null && session.description.isNotEmpty;
    if (isDescriptionAvailable)
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SessionDetailPage(
                session: session,
              ),
        ),
      );
  }

  void _fetchSessions() async {
    setState(() => _isLoading = true);
    try {
      var response = await api.getSessionList();
      setState(() => _sessions = response);
    } catch (ex) {
      print(ex);
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
