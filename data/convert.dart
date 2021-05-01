import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  var file = File.fromUri(Uri.parse(args[0]));
  print('Reading file: ${file.path}');
  var content = file.readAsStringSync();
  var data = json.decode(content);
  var users = data['__collections__']['users'] as Map;
  print('Total users: ${users.keys.length}');

  var lines = <String>[];
  lines.add(
      'name,email,phone,is_present,is_registered,designation,occupation,institute_work,contribution');
  for (String key in users.keys as Iterable<String>) {
    var user = users[key];

    if (user['email'] == null) continue;

    var values = <String?>[
      user['name'],
      user['email'],
      user['mobileNumber'],
      (user['isPresent'] as bool?).toString(),
      (user['isRegistered'] as bool?).toString(),
      user['registration'] == null ? '' : user['registration']['designation'],
      user['registration'] == null ? '' : user['registration']['occupation'],
      user['registration'] == null
          ? ''
          : user['registration']['workOrInstitute'],
      user['contribution'] == null ? '' : user['contribution'].toString(),
    ];
    var line = values.join(',');
    print(line);
    lines.add(line);
  }

  print('Writing ${lines.length} records to file');
  var outFile = File.fromUri(Uri.parse('export.csv'));
  outFile.createSync();
  outFile.writeAsStringSync(lines.join('\r\n'));

  print('Done');
}
