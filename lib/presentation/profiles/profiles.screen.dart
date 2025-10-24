import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/profiles.controller.dart';

class ProfilesScreen extends GetView<ProfilesController> {
  const ProfilesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfilesScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProfilesScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
