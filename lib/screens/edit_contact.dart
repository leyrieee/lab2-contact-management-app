import 'package:flutter/material.dart';
import '../services/api_services.dart';

/// A widget that provides a form to edit existing contacts.
///
/// Takes a contact Map as a required parameter and provides:
/// * Pre-filled form with existing contact details
/// * Input validation
/// * API integration for updates
/// * Navigation handling with success/failure states
class EditContact extends StatefulWidget {
  /// The contact data to be edited.
  ///
  /// Expected to contain 'pid', 'pname', and 'pphone' keys.
  final Map<String, dynamic> contact;

  /// Creates an Edit Contact page widget.
  ///
  /// Requires [contact] parameter containing the contact details to edit.
  const EditContact({super.key, required this.contact});

  @override
  EditContactState createState() => EditContactState();
}

/// The state class for the EditContact widget.
///
/// Manages:
/// * Text controllers for form fields
/// * Contact ID storage
/// * API interactions for updates
class EditContactState extends State<EditContact> {
  // Instance of ApiService for network requests
  final ApiService apiService = ApiService();

  // Controllers for text input fields
  late TextEditingController nameController;
  late TextEditingController phoneController;

  // Store contact ID for API operations
  late String contactId;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing contact data
    contactId = widget.contact["pid"].toString();
    nameController = TextEditingController(text: widget.contact["pname"]);
    phoneController = TextEditingController(text: widget.contact["pphone"]);
  }

  /// Handles the contact update process.
  ///
  /// This method:
  /// * Validates input fields
  /// * Makes API call to update contact
  /// * Shows success/failure messages
  /// * Handles navigation on success
  void editContact() async {
    // Input validation
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // Make API call to update contact
    String result = await apiService.editContact(
      contactId,
      nameController.text,
      phoneController.text,
    );

    // Safety check for widget mounted state
    if (!mounted) return;

    // Show success/failure message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result == "failed"
              ? "Failed to update contact"
              : "Contact updated successfully",
        ),
      ),
    );

    // Navigate back on success with true flag to trigger refresh
    if (result != "failed") {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with screen title
      appBar: AppBar(title: const Text("Edit Contact")),

      // Main content area with padding
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name input field
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            // Phone number input field with appropriate keyboard type
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
            ),
            // Spacing between fields and button
            const SizedBox(height: 20),
            // Update button
            ElevatedButton(
              onPressed: editContact,
              child: const Text("Update Contact"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers when widget is disposed
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
