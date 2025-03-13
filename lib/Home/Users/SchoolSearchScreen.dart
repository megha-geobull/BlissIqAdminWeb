import 'package:blissiqadmin/Services/PlacesServices.dart';
import 'package:blissiqadmin/auth/Controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class SchoolSearchScreen extends StatefulWidget {
  @override
  _SchoolSearchScreenState createState() => _SchoolSearchScreenState();
}

class _SchoolSearchScreenState extends State<SchoolSearchScreen> {
  final PlacesService _placesService = PlacesService();
  final AuthController mentorController = Get.put(AuthController());

  String? selectedSchool;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Search'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TypeAheadField(
              controller:  mentorController.searchController,
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Search for a school',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.search),
                  ),
                );
              },
              suggestionsCallback: (pattern) async {
                return await _placesService.getSchoolSuggestions(pattern);
              },
              itemBuilder: (context, Map<String, dynamic> suggestion) {
                return ListTile(
                  title: Text(suggestion['name']),
                );
              },
              onSelected: (Map<String, dynamic> suggestion) {
                setState(() {
                  selectedSchool = suggestion['name'];
                });
                mentorController.selectedSchoolName.value = suggestion['name'];
                mentorController.selectedSchoolAddress.value = suggestion['formatted_address'];
                mentorController.selectedSchoolLat.value = suggestion['lat'].toString();
                mentorController.selectedSchoolLng.value = suggestion['lng'].toString();
                mentorController.searchController.text = suggestion['name'];
                Get.back();
              },
            ),
            if (selectedSchool != null)
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Selected School: $selectedSchool',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}