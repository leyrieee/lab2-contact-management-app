import 'package:flutter/material.dart';
import '../services/api_services.dart';

/// A widget that provides a form to add new contacts to the application.
///
/// This screen contains:
/// * Input fields for name and phone number
/// * Submit button with loading state
/// * Error handling and success messages
/// * Integration with API service for data persistence
class AddContact extends StatefulWidget {
  /// Creates an Add Contact page widget.
  ///
  /// Uses a const constructor for widget optimization.
  const AddContact({super.key});

  @override
  AddContactState createState() => AddContactState();
}

/// The state class for the AddContact widget.
///
/// Manages the form state, user input, and API interactions.
class AddContactState extends State<AddContact> {
  // Instance of ApiService to handle network requests
  final ApiService apiService = ApiService();

  // Controllers for managing text input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Flag to track form submission state
  bool isSubmitting = false;

  /// Handles the contact addition process.
  ///
  /// This method:
  /// * Validates input fields
  /// * Shows loading indicator
  /// * Makes API call to add contact
  /// * Handles success/failure states
  /// * Updates UI accordingly
  void addContact() async {
    // Input validation
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    // Start loading state
    setState(() => isSubmitting = true);

    // API call to add contact
    String result =
        await apiService.addContact(nameController.text, phoneController.text);

    // End loading state
    setState(() => isSubmitting = false);

    // Handle API response
    if (result == "success") {
      // Check if widget is still mounted before showing success message
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Contact added!")));

      // Clear form fields on success
      nameController.clear();
      phoneController.clear();
    } else {
      // Check if widget is still mounted before showing error message
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Failed to add contact")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with screen title
      appBar: AppBar(title: const Text("Add Contact")),

      // Main content area with padding
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name input field
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name")),

            // Phone number input field
            TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone")),

            // Spacing between fields and button
            const SizedBox(height: 20),

            // Submit button with loading state handling
            ElevatedButton(
              onPressed: isSubmitting ? null : addContact,
              child: isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text("Add Contact"),
            ),
          ],
        ),
      ),
    );
  }
}
