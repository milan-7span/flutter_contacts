import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:contacts_service_example/contacts_list_page.dart';
import 'package:contacts_service_example/contacts_picker_page.dart';

import 'contacts_list_page.dart';
import 'contacts_picker_page.dart';

void main() => runApp(ContactsExampleApp());

// iOS only: Localized labels language setting is equal to CFBundleDevelopmentRegion value (Info.plist) of the iOS project
// Set iOSLocalizedLabels=false if you always want english labels whatever is the CFBundleDevelopmentRegion value.
const iOSLocalizedLabels = false;

class ContactsExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/add': (BuildContext context) => AddContactPage(),
        '/contactsList': (BuildContext context) => ContactListPage(),
        '/nativeContactPicker': (BuildContext context) => ContactPickerPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus != PermissionStatus.granted) {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    Permission permission = Permission.contacts;
    PermissionStatus permissionStatus = await permission.status;
    if (permissionStatus != PermissionStatus.granted &&
        permissionStatus != PermissionStatus.restricted) {
      PermissionStatus permissionStatus = await permission.request();
      return permissionStatus;
    } else {
      return PermissionStatus.denied;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    try {
      if (permissionStatus == PermissionStatus.denied) {
        throw PlatformException(
            code: "PERMISSION_DENIED",
            message: "Access to location data denied",
            details: null);
      } else if (permissionStatus == PermissionStatus.restricted) {
        throw PlatformException(
            code: "PERMISSION_DISABLED",
            message: "Location data is not available on device",
            details: null);
      }
    } catch (e) {
      print('e: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts Plugin Example')),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Contacts list'),
              onPressed: () => Navigator.pushNamed(context, '/contactsList'),
            ),
            ElevatedButton(
              child: const Text('Native Contacts picker'),
              onPressed: () =>
                  Navigator.pushNamed(context, '/nativeContactPicker'),
            ),
          ],
        ),
      ),
    );
  }
}
