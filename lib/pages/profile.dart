import 'package:chatapp/pages/chatPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../global/common.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';




class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController controller = TextEditingController();
  final List<String> data = ['Username', 'Name', 'Email', 'Phone number', 'Status Message'];
  final List<TextEditingController> controllers = [];
  String message = 'Find';
  String targetUserId = '';


  File? _selectedImage;
  String? _imageUrl;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
        print(_selectedImage);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    final uri = Uri.parse('${Common.baseUrl}api/user/upload-profile');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer ${Common.token}'
      ..files.add(await http.MultipartFile.fromPath('image', _selectedImage!.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        _imageUrl = responseData['image_url']; // Make sure backend returns this
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image upload failed')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    controllers.addAll(List.generate(data.length, (index) => TextEditingController()));
    // controller.text = 'Muralidharan_official';
    _fetchProfileImage();
    _getUserProfile();
  }

  Future<void> _fetchProfileImage() async {
    final response = await http.get(
      Uri.parse('${Common.baseUrl}api/user/get-profile'),
      headers: {'Authorization': 'Bearer ${Common.token}'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _imageUrl = data['results']['profile_image'];
      });
    }
  }

  Future<void> _getUserProfile() async {
    try {
      final uri = Uri.parse('${Common.baseUrl}api/user/get-profile');
      final res = await http.get(uri, headers: {'Authorization': 'Bearer ${Common.token}', 'Content-Type': 'application/json'});

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final user = data['results'];

        if (user != null) {
          controllers[0].text = user['username'] ?? '';
          controllers[1].text = user['name'] ?? '';
          controllers[2].text = user['email'] ?? '';
          controllers[3].text = user['phone_number'] ?? '';
          controllers[4].text = user['status_message'] ?? '';
        }
      } else if (res.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Not Found")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _onSave() async {
    // Collect the updated user profile data
    final updatedData = {
      'username': controllers[0].text,
      'name': controllers[1].text,
      'email': controllers[2].text,
      'phone_number': controllers[3].text,
      'status_message': controllers[4].text,
    };

    try {
      final uri = Uri.parse('${Common.baseUrl}api/user/update-profile');
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer ${Common.token}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        // Successfully updated
        final responseBody = jsonDecode(response.body);
        String message = responseBody['message'] ?? 'Profile updated successfully';

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          backgroundColor: Colors.green, // Success background color
        ));
      } else if (response.statusCode == 409) {
        final responseBody = jsonDecode(response.body);
        // Conflict (e.g., user already exists)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseBody['error']),
          backgroundColor: Colors.red, // Error background color
        ));
      } else {
        // Handle other status codes (e.g., 400, 500)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Unexpected error occurred. Please try again later.'),
          backgroundColor: Colors.red, // Error background color
        ));
      }
    } catch (e) {
      // Handle errors like network issues
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${e.toString()}"),
        backgroundColor: Colors.red, // Error background color
      ));
    }
  }


  @override
  void dispose() {
    controller.dispose();
    controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset('assets/images/arrow2-svg.svg', height: 30, width: 30, color: Common.white),
            ),
            SizedBox(width: 15),
            Text('Profile', style: TextStyle(color: Common.white, fontSize: Common.h1, fontWeight: FontWeight.w100)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: _onSave,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>((states) => Common.receive),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            ),
            child: Text("SAVE", style: TextStyle(color: Common.white)),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  image: _imageUrl != null
                      ? DecorationImage(
                    image: NetworkImage(Common.baseUrl+_imageUrl!),
                    fit: BoxFit.cover,
                  )
                      : null,
                ),
                child: _imageUrl == null
                    ? Icon(Icons.person, size: 50)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.edit, size: 18),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(28), topRight: Radius.circular(28)),
              ),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 22, right: 22, top: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(data[index], style: TextStyle(fontSize: Common.h3, fontWeight: FontWeight.bold, color: Common.send)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
                        child: TextField(
                          controller: controllers[index],
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Common.receive,
                            hintText: 'Enter ${data[index]}',
                            hintStyle: TextStyle(color: Common.white.withOpacity(0.5), fontSize: Common.h3),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                          ),
                          style: TextStyle(color: Common.white, fontSize: Common.h2),
                          cursorColor: Common.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}