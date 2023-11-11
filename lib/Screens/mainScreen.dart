import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:top_tier/Custom%20Data/Clients.dart';

import 'Retail Screens/RetailSelectionScreen.dart';
import 'Settings Screens/OpeningSettingScreen.dart';
import 'Social Screens/MainSocialScreen.dart';




class MainScreen extends StatefulWidget {
 Client client;

 MainScreen({super.key, required this.client});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Widget? _child;


  @override
  void initState() {
    super.initState();

    _child = RetailSelectionScreen(client: widget.client);

    ///change this to separate screen
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBody: true,
        body: _child,
        bottomNavigationBar: FluidNavBar(
          icons: [
            FluidNavBarIcon(
                icon: Icons.store,
                backgroundColor: Colors.grey,
                extras: {'label': 'Store'}),
            FluidNavBarIcon(
                icon: Icons.people,
                backgroundColor: Colors.grey,
                extras: {'label': 'News'}),
            FluidNavBarIcon(
                icon: Icons.settings,
                backgroundColor: Colors.grey,
                extras: {'label': 'Settings'})
          ],
          onChange: _handleNavigationChange,
          style: const FluidNavBarStyle(
              iconUnselectedForegroundColor: Colors.black,
              iconSelectedForegroundColor: Color(0xffef6def),
              barBackgroundColor: Color(0xffef6def)),
          scaleFactor: 1.5,
          defaultIndex: 0,
          itemBuilder: (icon, item) => Semantics(
            label: icon.extras!['label'],
            child: item,
          ),
        ),
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = RetailSelectionScreen(client: widget.client);
          break;
        case 1:
          _child = MainSocialScreen(
            client: widget.client,
          );
          break;
        case 2:
          _child = OpeningSettingScreen(client: widget.client);
          break;
      }

      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeIn,
        duration: const Duration(milliseconds: 500),
        child: _child,
      );
    });
  }
}
