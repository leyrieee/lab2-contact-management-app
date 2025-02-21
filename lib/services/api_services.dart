// ignore_for_file: depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

/// Service class for handling all API interactions for contact management.
///
/// Provides methods for:
/// * Fetching all contacts
/// * Fetching single contact details
/// * Adding new contacts
/// * Updating existing contacts
/// * Deleting contacts
///
/// Uses Dio for HTTP requests and Logger for debugging.
class ApiService {
  /// Dio instance for making HTTP requests
  final Dio dio = Dio();

  /// Logger instance for debugging and error tracking
  final logger = Logger();

  /// Fetches all contacts from the API.
  ///
  /// Returns a List of Maps containing contact information.
  /// Returns an empty list if the request fails.
  ///
  /// Handles both direct JSON responses and string-encoded JSON responses.
  Future<List<Map<String, dynamic>>> getAllContacts() async {
    try {
      final response = await dio.get(
        "https://apps.ashesi.edu.gh/contactmgt/actions/get_all_contact_mob",
      );

      // Log response details for debugging
      logger.i("Raw API Response Type: ${response.data.runtimeType}");
      logger.i("Raw API Response: ${response.data}");

      // Handle both string-encoded and direct JSON responses
      final dynamic data =
          response.data is String ? jsonDecode(response.data) : response.data;

      // Ensure response is in expected format
      if (data is List) {
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception("Unexpected response format: $data");
      }
    } catch (e) {
      logger.e("Error fetching contacts: $e");
      return [];
    }
  }

  /// Fetches a single contact by ID.
  ///
  /// Parameters:
  /// * [contId] - The unique identifier of the contact
  ///
  /// Returns the contact data as a Map, or null if the request fails.
  Future<Map<String, dynamic>?> getSingleContact(String contId) async {
    try {
      final response = await dio.get(
        "https://apps.ashesi.edu.gh/contactmgt/actions/get_a_contact_mob?contid=$contId",
      );
      return response.data;
    } catch (e) {
      logger.e("Error fetching contact: $e");
      return null;
    }
  }

  /// Adds a new contact to the system.
  ///
  /// Parameters:
  /// * [name] - The full name of the contact
  /// * [phone] - The phone number of the contact
  ///
  /// Returns "success" or "failed" based on the operation outcome.
  Future<String> addContact(String name, String phone) async {
    try {
      // Create form data with contact details
      final formData =
          FormData.fromMap({"ufullname": name, "uphonename": phone});
      final response = await dio.post(
        "https://apps.ashesi.edu.gh/contactmgt/actions/add_contact_mob",
        data: formData,
      );
      return response.data.toString();
    } catch (e) {
      logger.e("Error adding contact: $e");
      return "failed";
    }
  }

  /// Updates an existing contact's information.
  ///
  /// Parameters:
  /// * [id] - The unique identifier of the contact
  /// * [name] - The updated full name
  /// * [phone] - The updated phone number
  ///
  /// Returns "success" or "failed" based on the operation outcome.
  Future<String> editContact(String id, String name, String phone) async {
    try {
      // Create form data with updated contact details
      final formData =
          FormData.fromMap({"cid": id, "cname": name, "cnum": phone});
      final response = await dio.post(
        "https://apps.ashesi.edu.gh/contactmgt/actions/update_contact",
        data: formData,
      );
      return response.data.toString();
    } catch (e) {
      logger.e("Error updating contact: $e");
      return "failed";
    }
  }

  /// Deletes a contact from the system.
  ///
  /// Parameters:
  /// * [id] - The unique identifier of the contact to delete
  ///
  /// Returns true if deletion was successful, false otherwise.
  Future<bool> deleteContact(String id) async {
    try {
      // Create form data with contact ID
      final formData = FormData.fromMap({"cid": id});
      final response = await dio.post(
        "https://apps.ashesi.edu.gh/contactmgt/actions/delete_contact",
        data: formData,
      );
      return response.statusCode == 200;
    } catch (e) {
      logger.e("Error deleting contact: $e");
      return false;
    }
  }
}
