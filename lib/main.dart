import 'package:flutter/material.dart';
import 'screens/contacts_list.dart';
import 'screens/add_contact.dart';
import 'screens/about.dart';

/// Entry point of the application.
void main() {
  runApp(const MyApp());
}

/// Root widget of the Contact Management application.
///
/// Sets up the MaterialApp with:
/// * Theme configuration
/// * App title
/// * Home screen navigation
class MyApp extends StatelessWidget {
  /// Creates the root app widget.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // Enable Material 3 design system
      ),
      home: const HomeScreen(),
    );
  }
}

/// Main navigation screen of the application.
///
/// Provides:
/// * Bottom navigation bar
/// * Screen switching functionality
/// * Access to main app features:
///   - Contacts list
///   - Add contact form
///   - About page
class HomeScreen extends StatefulWidget {
  /// Creates the home screen widget.
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// State class for HomeScreen widget.
///
/// Manages:
/// * Currently selected screen index
/// * Navigation between main app screens
class _HomeScreenState extends State<HomeScreen> {
  // Index of currently selected screen
  int _selectedIndex = 0;

  // List of main app screens
  final List<Widget> _screens = [
    const ContactsList(),
    const AddContact(),
    const About(),
  ];

  /// Handles bottom navigation bar item selection.
  ///
  /// Updates the selected index to switch the displayed screen.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the currently selected screen
      body: _screens[_selectedIndex],

      // Bottom navigation bar for main app navigation
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // Contacts list navigation item
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          // Add contact form navigation item
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Contact',
          ),
          // About page navigation item
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
