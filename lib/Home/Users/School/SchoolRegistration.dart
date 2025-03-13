import 'dart:async';

import 'package:blissiqadmin/Global/Routes/AppRoutes.dart';
import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/auth/Controller/SchoolController/SchoolController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

class SchoolRegistration extends StatefulWidget {
  @override
  _SchoolRegistrationState createState() => _SchoolRegistrationState();
}

class _SchoolRegistrationState extends State<SchoolRegistration> {
  final SchoolController schoolController = Get.put(SchoolController());

  LatLng? selectedLocation;
  String selectedAddress = '';
  String selectedPlaceName = '';

  bool isLocationAllowed = false, isLocationPermissionChecked = false;
  String latitudel1 = '', longitudel2 = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (isLocationAllowed == false && isLocationPermissionChecked == false) {
      _getCurrentLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;

          return Row(
            children: [
              if (isWideScreen)
                Container(
                  width: 250,
                  color: Colors.orange.shade100,
                  child: MyDrawer(),
                ),
              Expanded(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade50,
                  appBar: isWideScreen
                      ? null
                      : AppBar(
                          title: const Text('Dashboard'),
                          scrolledUnderElevation: 0,
                          backgroundColor: Colors.blue.shade100,
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                  drawer: isWideScreen ? null : Drawer(child: MyDrawer()),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: _buildSchoolMainContent(constraints),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSchoolMainContent(BoxConstraints constraints) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.38,
              child: Builder(builder: (context) {
                return  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset('assets/business.png', height: 100),
                      // const SizedBox(height: 30),
                      const Text(
                        'School Registration',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      boxH20(),

                      CustomTextField(
                        controller: schoolController.schoolNameController,
                        labelText: 'School Name',
                        onChanged: (value) {
                          openMapBottomSheet(
                              context,
                              schoolController.schoolNameController,
                              schoolController.addressController);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the school name';
                          }
                          return null;
                        },
                        prefixIcon: const Icon(Icons.school_outlined),
                      ),
                      boxH20(),

                      CustomTextField(
                        controller: schoolController.schoolRegNumberController,
                        labelText: 'School Registration Number',
                        inputFormatters: [LengthLimitingTextInputFormatter(12)],
                        prefixIcon: const Icon(Icons.assignment),
                      ),

                      boxH20(),

                      CustomTextField(
                        controller: schoolController.principalNameController,
                        keyboardType: TextInputType.text,
                        labelText: 'Principal/Administrator Name',
                        prefixIcon: const Icon(Icons.person_2_outlined),
                      ),
                      boxH20(),

                      CustomTextField(
                        controller: schoolController.principalEmailController,
                        labelText: 'Principal/Administrator Email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),

                      boxH20(),

                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0)),
                                border: Border.all(
                                    width: 1, color: Colors.blueAccent),
                              ),
                              height: 50,
                              alignment: Alignment.centerLeft,
                              child: CountryCodePicker(
                                onChanged: schoolController.onCountryChange,
                                initialSelection: 'IN',
                                favorite: ['+91', 'IN'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: SizedBox(
                              height: 50,
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter your mobile number';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                controller:
                                    schoolController.principalPhoneController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  hintText: 'Enter mobile number',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      boxH20(),

                      CustomTextField(
                        controller: schoolController.addressController,
                        labelText: 'School Address',
                        maxLines: 3,
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      boxH20(),
                      CustomTextField(
                        controller: schoolController.schoolTypeController,
                        labelText: 'School Type',
                        maxLines: 1,
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      // Obx(() => DropdownButtonFormField<String>(
                      //       value: schoolController.schoolType.value.isEmpty
                      //           ? null
                      //           : schoolController.schoolType.value,
                      //       items: schoolController.schoolTypes
                      //           .map((type) => DropdownMenuItem<String>(
                      //                 value: type,
                      //                 child: Text(type),
                      //               ))
                      //           .toList(),
                      //       onChanged: (value) {
                      //         schoolController.schoolType.value = value!;
                      //       },
                      //       decoration: const InputDecoration(
                      //         prefixIcon: Icon(Icons.school),
                      //         labelText: 'School Type',
                      //         border: OutlineInputBorder(),
                      //       ),
                      //     )),
                      boxH20(),
                      CustomTextField(
                        controller:
                            schoolController.affiliatedCompanyController,
                        labelText: 'Affiliated Company',
                        maxLines: 1,
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      // Obx(() => DropdownButtonFormField<String>(
                      //       value: schoolController.affiliatedCompany.value.isEmpty
                      //           ? null
                      //           : schoolController.affiliatedCompany.value,
                      //       items: schoolController.affiliatedCompanies
                      //           .map((company) => DropdownMenuItem<String>(
                      //                 value: company,
                      //                 child: Text(company),
                      //               ))
                      //           .toList(),
                      //       onChanged: (value) {
                      //         schoolController.affiliatedCompany.value = value!;
                      //       },
                      //       decoration: const InputDecoration(
                      //         labelText: 'Affiliated Company',
                      //         prefixIcon: Icon(Icons.business),
                      //         border: OutlineInputBorder(),
                      //       ),
                      //     )),
                      boxH30(),

                      CustomTextField(
                        controller: schoolController.passwordController,
                        labelText: 'Enter your password',
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(Icons.password_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter your password';
                          }
                          return null;
                        },
                        obscureText: !schoolController.isPasswordVisible.value,
                        sufixIcon: IconButton(
                          icon: Icon(schoolController.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              schoolController.isPasswordVisible.value =
                                  !schoolController.isPasswordVisible.value;
                            });
                          },
                        ),
                      ),
                      boxH20(),
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Confirm your password';
                          } else if (value !=
                              schoolController.confirmPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        controller: schoolController.confirmPasswordController,
                        labelText: 'Confirm your password',
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(Icons.password_rounded),
                        obscureText:
                            !schoolController.isConfirmPasswordVisible.value,
                        sufixIcon: IconButton(
                          icon: Icon(
                              schoolController.isConfirmPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              schoolController.isConfirmPasswordVisible.value =
                                  !schoolController
                                      .isConfirmPasswordVisible.value;
                            });
                          },
                        ),
                      ),
                      boxH20(),

                      ElevatedButton(
                        onPressed: () {
                          if (schoolController.selectedLatitude.value.isEmpty && schoolController.selectedLongitude.value.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select a location')),
                            );
                            return;
                          }
                          schoolController.schoolRegistrationApi(
                            schoolName: schoolController.schoolNameController.text,
                            schoolRegNumber: schoolController.schoolRegNumberController.text,
                            principalName: schoolController.principalNameController.text,
                            principalEmail: schoolController.principalEmailController.text,
                            principalPhone: schoolController.principalPhoneController.text,
                            address: schoolController.addressController.text, // Use the selected address
                            schoolType: schoolController.schoolTypeController.text,
                            affiliatedCompany: schoolController.affiliatedCompanyController.text,
                            password: schoolController.passwordController.text,
                            confirmPassword: schoolController.confirmPasswordController.text,
                            lat: schoolController.selectedLatitude.value,
                            long: schoolController.selectedLongitude.value,
                            context: context,
                          ).then((response) {
                            Navigator.pop(context, true);
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error occurred: $error')),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    ],
                  );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void openMapBottomSheet(
      BuildContext context,
      TextEditingController schoolNameController,
      TextEditingController addressController) {
    final places =
        GoogleMapsPlaces(apiKey: 'AIzaSyCY4i1-nQFNVTSYetMw7aofzBRwGvCH_Ms');
    LatLng? selectedLocation;
    String selectedAddress = '';
    String selectedPlaceName = '';

    // Controller to manipulate the Google Map
    Completer<GoogleMapController> _mapController = Completer();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: schoolController.searchController,
                    decoration: InputDecoration(
                      labelText: 'Search for a school',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          if (schoolController.searchController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please enter a search term.")),
                            );
                            return;
                          }
                          if (selectedLocation != null) {
                            schoolNameController.text = selectedPlaceName;
                            addressController.text = selectedAddress;

                            schoolController.updateLocation(
                              selectedLocation!.latitude,
                              selectedLocation!.longitude,
                            );
                            Navigator.pop(context);
                            // You can store the selectedLocation, selectedPlaceName, and selectedAddress here
                            print("Latitude: ${selectedLocation!.latitude}");
                            print("Longitude: ${selectedLocation!.longitude}");
                            print("Place Name: $selectedPlaceName");
                            print("Address: $selectedAddress");
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please select a location on the map.")),
                            );
                          }

                          // Perform search using Google Places API
                          try {
                            PlacesSearchResponse response =
                                await places.searchByText(
                                    schoolController.searchController.text);
                            if (response.results.isNotEmpty) {
                              var place = response.results.first;
                              setState(() {
                                selectedLocation = LatLng(
                                    place.geometry!.location.lat,
                                    place.geometry!.location.lng);
                                schoolController.updateLocation(
                                  selectedLocation!.latitude,
                                  selectedLocation!.longitude,
                                );
                                selectedPlaceName = place.name;
                                selectedAddress = place.formattedAddress ?? '';
                              });


                              // Move the camera to the searched location
                              final GoogleMapController controller =
                                  await _mapController.future;
                              controller.animateCamera(
                                CameraUpdate.newLatLng(selectedLocation!),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("No results found.")),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Error searching for location: $e")),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: selectedLocation ??
                            LatLng(
                              double.tryParse(latitudel1) ?? 18.552,
                              double.tryParse(longitudel2) ?? 73.850,
                            ),
                        zoom: 14.0,
                      ),
                      markers: selectedLocation != null
                          ? {
                              Marker(
                                markerId: const MarkerId('selectedLocation'),
                                position: selectedLocation!,
                              ),
                            }
                          : {},
                      onTap: (LatLng location) async {
                        try {
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                  location.latitude, location.longitude);
                          if (placemarks.isNotEmpty) {
                            Placemark place = placemarks.first;
                            setState(() {
                              selectedLocation = location;
                              selectedPlaceName = place.name ?? 'Unknown Place';
                              selectedAddress =
                                  "${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}";
                            });

                            // Move the camera to the tapped location
                            final GoogleMapController controller =
                                await _mapController.future;
                            controller.animateCamera(
                              CameraUpdate.newLatLng(selectedLocation!),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Could not fetch address for the selected location.")),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Error fetching address: $e")),
                          );
                        }
                      },
                      onMapCreated: (GoogleMapController controller) {
                        _mapController.complete(controller);
                      },
                    ),
                  ),
                  if (selectedPlaceName.isNotEmpty)
                    Text('Selected Place: $selectedPlaceName'),
                  if (selectedAddress.isNotEmpty)
                    Text('Address: $selectedAddress'),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedLocation != null) {
                        schoolNameController.text = selectedPlaceName;
                        addressController.text = selectedAddress;
                        Navigator.pop(context);
                        // You can store the selectedLocation, selectedPlaceName, and selectedAddress here
                        print("Latitude: ${selectedLocation!.latitude}");
                        print("Longitude: ${selectedLocation!.longitude}");
                        print("Place Name: $selectedPlaceName");
                        print("Address: $selectedAddress");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text("Please select a location on the map.")),
                        );
                      }
                    },
                    child: const Text('Select Location'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Get Current Location API
  _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, cannot request permissions.');
      }

      // Fetch current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      if (position == null) {
        return Future.error('Failed to get current location.');
      }

      double latitude = position.latitude;
      double longitude = position.longitude;

      // Handle possible errors with placemark retrieval
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude)
              .catchError((error) {
        print("Error fetching placemark: $error");
        return [];
      });

      if (placemarks.isNotEmpty) {
        latitudel1 = latitude.toString();
        longitudel2 = longitude.toString();
        print("Latitude: $latitudel1, Longitude: $longitudel2");

        if (mounted) {
          setState(() {});
        }
      } else {
        print("No placemarks found.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
