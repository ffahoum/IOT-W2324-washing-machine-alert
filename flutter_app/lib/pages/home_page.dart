import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:washwatch/Pages/jobs_page.dart';
import 'package:washwatch/Pages/subscribed_page.dart';
import 'package:washwatch/components/information_dialog.dart';
import 'package:washwatch/components/progress_indicator.dart';
import 'package:washwatch/providers/auth_service.dart';
import 'catalog_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage() ;
}

class _HomePage extends State<HomePage>  with AutomaticKeepAliveClientMixin{
    @override
  bool get wantKeepAlive => true;
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    CatalogPage(), 
    JobsPage(),
    SubscribedPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController!.jumpToPage(index);
    });
  }
  PageController? _pageController;

  
  signOut() async {
     GlobalKey<State> _dialogKey = GlobalKey<State>();
    showProgressIndicator(context, _dialogKey);
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(_dialogKey.currentContext!, rootNavigator: true).pop();
    AuthService.signOut();
  }
  
    StreamSubscription<ConnectivityResult>? subscription;
  var connectionStatus;
  var previousConnectionStatus = ConnectivityResult.wifi;
  bool isInitialized = false;


 @override
  void initState() {
      _pageController = PageController(initialPage: _selectedIndex, keepPage: true);
    super.initState();
    Connectivity().checkConnectivity().then((ConnectivityResult result) {
      setState(() {
        previousConnectionStatus = result;
        connectionStatus = result;
        isInitialized = true;
      });
      if (connectionStatus == ConnectivityResult.none) {
        showConnectionLostSnackbar();
      }
    });

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {         
      setState(() {
        previousConnectionStatus = connectionStatus;
        connectionStatus = result;
      });
      if (isInitialized) {
        checkInternetConnectivity();
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      updateTokenInDatabase(newToken);
    });
  }

void updateTokenInDatabase(String newToken) {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    // Update the token in the database
    FirebaseDatabase.instance.ref().child('users/$userId/token').set(newToken).then((_) {
      print('User $userId\'s token has been updated to: $newToken');
    }).catchError((error) {
      print('Failed to update user token: $error');
    });
  }


@override
void dispose() {
  subscription!.cancel(); 
  super.dispose();
}

  
  void showConnectionLostSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Connection Lost: Please check your internet connection',
          style: GoogleFonts.robotoCondensed(
            fontSize: 12, 
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showConnectionRestoredSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Connection Restored: You're back online!",
          style: GoogleFonts.robotoCondensed(
            fontSize: 12, 
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green[400],
      ),
    );
  }


    
  checkInternetConnectivity() {
    if (previousConnectionStatus == ConnectivityResult.none &&
        connectionStatus != ConnectivityResult.none) {
      // Connection restored
      showConnectionRestoredSnackbar();
    } else if (connectionStatus == ConnectivityResult.none) {
      // Connection lost
      showConnectionLostSnackbar();
    }
  }


  void showInfoDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const InformationDialog();
    },
  );    
  }
  
    @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor:  Colors.grey[300],
      body: Column(
        children: [
          
          SizedBox(height: 30), 
          AppBar(
            backgroundColor: Colors.grey[300],
              centerTitle: true, 
              title: Text(
                'WASH WATCH',
                style: GoogleFonts.bebasNeue(
                  fontSize: 52,
                  color:  Colors.grey[700],
                )
              ),
              actions: [
                IconButton(onPressed: showInfoDialog, icon: Icon(Icons.info)),
                IconButton(onPressed: signOut, icon: Icon(Icons.exit_to_app)),
              ],
            ),
            SizedBox(height: 30), 
          Expanded(
            child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: _pages,
              ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category), // Icon for catalog page
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment), // Icon for jobs page
            label: 'Jobs',
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.list_alt), // Icon for catalog page
            label: 'Subscribed',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor:  Colors.grey[200],
        selectedLabelStyle: GoogleFonts.bebasNeue(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
        unselectedLabelStyle: GoogleFonts.bebasNeue(
                  fontSize: 14,
                ),
      ),
    );
  }
}
