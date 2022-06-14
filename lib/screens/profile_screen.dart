import 'dart:convert';
import 'dart:typed_data';
import 'package:local_app_shared_preferences/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MemoryImage? selectedImage;
  TextEditingController nameCntlr = TextEditingController();
  TextEditingController hobbyCntlr = TextEditingController();
  TextEditingController foodCntlr = TextEditingController();
  final GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> hobbyKey = GlobalKey<FormState>();
  final GlobalKey<FormState> foodKey = GlobalKey<FormState>();

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  Future<void> pickImage() async {
    final XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      final fileBytes = await file.readAsBytes();
      final bytes = base64Encode(fileBytes);

      final pref = await SharedPreferences.getInstance();
      await pref.setString('profileImage', bytes);
      await getImage();
    }
    setState(() {});
  }

  Future<void> saveInfo() async {
    final validNameForm = nameKey.currentState?.validate();
    final validhobbyForm = hobbyKey.currentState?.validate();
    final validFoodForm = foodKey.currentState?.validate();
    if (validNameForm == true &&
        validhobbyForm == true &&
        validFoodForm == true &&
        nameCntlr.text.isNotEmpty &&
        hobbyCntlr.text.isNotEmpty &&
        foodCntlr.text.isNotEmpty) {
      final userModel = UserModel(
        name: nameCntlr.text,
        hobby: hobbyCntlr.text,
        food: foodCntlr.text,
      );

      EasyLoading.show();
      final pref = await SharedPreferences.getInstance();

      await pref.setString('userModel', userModel.toJson());
      await getImage();
      EasyLoading.dismiss();
    }
  }

  Future<void> getUserInfo() async {
    EasyLoading.show();
    final pref = await SharedPreferences.getInstance();

    final userInfo = pref.getString('userModel');
    if (userInfo != null) {
      final userModel = UserModel.fromJson(userInfo);
      nameCntlr = TextEditingController(text: userModel.name);
      hobbyCntlr = TextEditingController(text: userModel.hobby);
      foodCntlr = TextEditingController(text: userModel.food);
      await getImage();
    }
    debugPrint(userInfo);
    EasyLoading.dismiss();
    setState(() {});
  }

  Future<void> getImage() async {
    final pref = await SharedPreferences.getInstance();
    final cachedImage = pref.getString('profileImage');
    if (cachedImage != null) {
      Uint8List bytes = base64Decode(cachedImage);
      selectedImage = MemoryImage(bytes);
    }
    setState(() {});
  }

  String? _validator(value) {
    if (value == null || value.isEmpty) {
      return 'field required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: selectedImage,
                  child: selectedImage == null
                      ? const Icon(Icons.photo)
                      : Container(),
                ),
                onTap: () => pickImage(),
              ),
              const SizedBox(height: 32),
              Form(
                key: nameKey,
                child: TextFormField(
                  controller: nameCntlr,
                  decoration: const InputDecoration(hintText: 'Name'),
                  validator: _validator,
                  onChanged: (value) {
                    nameKey.currentState?.validate();
                  },
                ),
              ),
              Form(
                key: hobbyKey,
                child: TextFormField(
                  controller: hobbyCntlr,
                  decoration: const InputDecoration(hintText: 'Hobby'),
                  validator: _validator,
                  onChanged: (value) {
                    hobbyKey.currentState?.validate();
                  },
                ),
              ),
              Form(
                key: foodKey,
                child: TextFormField(
                  controller: foodCntlr,
                  decoration: const InputDecoration(hintText: 'Favorite food'),
                  validator: _validator,
                  onChanged: (value) {
                    foodKey.currentState?.validate();
                  },
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () => saveInfo(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
