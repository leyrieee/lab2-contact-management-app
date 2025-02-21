// ignore_for_file: depend_on_referenced_packages

import 'package:contact_management_app/screens/edit_contact.dart';
import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'package:logger/logger.dart';

/// Initialize logger instance for debugging and tracking
final logger = Logger();

/// A widget that displays a list of contacts with edit and delete functionality.
///
/// Features:
/// * Displays all contacts in a scrollable list
/// * Pull-to-refresh functionality
/// * Edit and delete options for each contact
/// * Loading states and error handling
/// * Confirmation dialogs for deletions
class ContactsList extends StatefulWidget {
  /// Creates a Contacts List page widget.
  const ContactsList({super.key});

  @override
  ContactsListState createState() => ContactsListState();
}

/// The state class for the ContactsList widget.
///
/// Manages:
/// * Contact data fetching and storage
/// * Loading states
/// * CRUD operations on contacts
class ContactsListState extends State<ContactsList> {
  // Instance of ApiService for network requests
  final ApiService apiService = ApiService();

  // List to store fetched contacts
  List<Map<String, dynamic>> contacts = [];

  // Flag to track loading state
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch contacts when widget is first created
    fetchContacts();
  }

  /// Fetches all contacts from the API and updates the state.
  ///
  /// Sets loading state while fetching and logs the total number
  /// of contacts retrieved.
  Future<void> fetchContacts() async {
    setState(() => isLoading = true);
    contacts = await apiService.getAllContacts();
    logger.i("Total Contacts Fetched: ${contacts.length}");
    setState(() => isLoading = false);
  }

  /// Shows a confirmation dialog and handles contact deletion.
  ///
  /// Parameters:
  /// * [id] - The unique identifier of the contact
  /// * [name] - The name of the contact for display purposes
  void deleteContact(String id, String name) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete $name?"),
        actions: [
          // Cancel button to dismiss dialog
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          // Delete button with confirmation action
          TextButton(
            onPressed: () async {
              // Close dialog before starting async operation
              Navigator.pop(dialogContext);

              // Attempt to delete contact
              bool success = await apiService.deleteContact(id);
              if (!mounted) return; // Safety check for widget mounted state

              if (success) {
                // Refresh contacts list on successful deletion
                fetchContacts();
                if (!mounted) {
                  return;
                } // Additional mounted check after async operation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$name deleted")),
                );
              } else {
                // Show error message if deletion fails
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to delete $name")),
                );
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(title: const Text("Contacts")),

      // Main body with loading state handling
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchContacts,
              child: SingleChildScrollView(
                // Enable scrolling even when content doesn't fill screen
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: contacts.map((contact) {
                    // Create a list tile for each contact
                    return ListTile(
                      title: Text(contact["pname"]),
                      subtitle: Text(contact["pphone"]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit button and navigation
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              // Navigate to edit page and refresh if changes made
                              bool? updated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditContact(contact: contact),
                                ),
                              );
                              if (updated == true) {
                                fetchContacts();
                              }
                            },
                          ),
                          // Delete button with confirmation
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteContact(
                                contact["pid"].toString(), contact["pname"]),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
    );
  }
}
