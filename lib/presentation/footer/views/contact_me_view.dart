import 'dart:convert';
import 'package:atlas_icons/atlas_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:portfolio/domain/models/contact_details_model/contact.details.model.dart';
import 'package:portfolio/infrastructure/dal/services/add.contact.service.dart';
import 'package:get/get.dart';
import '../../../infrastructure/dal/services/ping.server.dart';

class ContactMeView extends StatefulWidget {
  const ContactMeView({super.key});

  @override
  State<ContactMeView> createState() => _ContactMeViewState();
}

class _ContactMeViewState extends State<ContactMeView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _countryCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final Logger _logger = Logger();

  @override
  void dispose() {
    _nameController.dispose();
    _countryCodeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController.clear();
    _countryCodeController.clear();
    _phoneController.clear();
    _emailController.clear();
    _messageController.clear();

    final PingServerService pingServerService = PingServerService();
    _ping(pingServerService);
  }

  Future<void> _ping(PingServerService pingServerService) async {
    final Logger logger = Logger();
    try {
      final result = await pingServerService.ping();
      if (result == 'true') {
        logger.i('Server connected');
      } else {
        logger.w('Server not connected, try again');
      }
    } catch (e) {
      logger.e('Server not connected, try again');
    }
    await Future.delayed(const Duration(seconds: 5));
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final countryCode = _countryCodeController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    final now = DateTime.now();
    final date = DateFormat('MMMM d, yyyy').format(now);
    final time = DateFormat('hh:mm a').format(now);
    final contactForm = ContactDetailsModel(
      name: name,
      countryCode: countryCode,
      phoneNumber: phone,
      email: email,
      message: message,
      date: date,
      time: time,
    );
    final AddContactService addContactService = AddContactService();
    final response = await addContactService.addContact(contactForm);
    _logger.i('Response from server: ${jsonEncode(contactForm.toJson())}');

    if (response == 'true') {
      Get.closeAllSnackbars();
      Get.snackbar(
        'Success',
        'Message sent successfully',
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 28),
        backgroundColor: Colors.green.shade50,
        colorText: Colors.black,
        barBlur: 0.7,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: 12,
      );
      if (context.mounted) {
        Navigator.of(context).maybePop();
      }
    } else {
      Get.closeAllSnackbars();
      Get.snackbar(
        'Error',
        'Failed to send message: \n$response',
        snackPosition: SnackPosition.BOTTOM,
        icon: const Icon(Icons.error_outline, color: Colors.red, size: 28),
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
        barBlur: 0.7,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        borderRadius: 12,
      );
      _logger.e('Failed to send message: $response');
    }
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    required BuildContext context,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.white.withAlpha((0.7 * 255).round()),
        fontSize: 15,
        fontFamily: 'Poppins',
      ),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      prefixIcon: Icon(
        icon,
        color: Colors.white.withAlpha((0.8 * 255).round()),
        size: 22,
      ),
      filled: true,
      fillColor: const Color(0xFF001529).withAlpha((0.4 * 255).round()),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).round()),
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).round()),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: const Color(0xFF0A4A8E).withAlpha((0.7 * 255).round()),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.red.withAlpha((0.5 * 255).round()),
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int minLines = 1,
    int maxLines = 1,
    double? width,
    TextInputType? keyboardType,
    required BuildContext context,
    required String? Function(String?) validator,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) {
    final field = TextFormField(
      controller: controller,
      style: TextStyle(
        color: Colors.white.withAlpha((0.95 * 255).round()),
        fontSize: 15,
        fontFamily: 'Poppins',
      ),
      textAlign: TextAlign.start,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label: label, icon: icon, context: context),
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
    );
    return width != null ? SizedBox(width: width, child: field) : field;
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Contact Me",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white.withAlpha((0.95 * 255).round()),
              fontFamily: 'Poppins',
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF8B0000).withAlpha((0.4 * 255).round()),
                const Color(0xFF4B0000).withAlpha((0.3 * 255).round()),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFFF4444).withAlpha((0.3 * 255).round()),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.close_rounded, size: 24),
            onPressed: () => Navigator.of(context).maybePop(),
            tooltip: 'Close',
            color: Colors.white.withAlpha((0.95 * 255).round()),
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(
                const Color(0xFFFF4444).withAlpha((0.2 * 255).round()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            width: 600,
            // ✅ REMOVED: Fixed height constraints
            // Now container auto-sizes to content
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0A1628).withAlpha((0.95 * 255).round()),
                  const Color(0xFF001529).withAlpha((0.9 * 255).round()),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).round()),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.5 * 255).round()),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ✅ Auto-size to content
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(context),
                const SizedBox(height: 8),
                Divider(
                  height: 1,
                  color: const Color(0xFF0A4A8E).withAlpha((0.3 * 255).round()),
                ),
                const SizedBox(height: 24),
                // ✅ REMOVED: Expanded widget that was forcing height
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTextFormField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Atlas.users,
                        context: context,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Please enter your name'
                            : null,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {},
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildTextFormField(
                            controller: _countryCodeController,
                            label: '+91',
                            icon: Icons.flag_outlined,
                            width: 100,
                            keyboardType: TextInputType.phone,
                            context: context,
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Code?'
                                : null,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {},
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextFormField(
                              controller: _phoneController,
                              label: 'Phone Number',
                              icon: Atlas.phonebook,
                              keyboardType: TextInputType.phone,
                              context: context,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'Phone?'
                                  : null,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _emailController,
                        label: 'Email Address',
                        icon: Atlas.inbox_mailbox,
                        keyboardType: TextInputType.emailAddress,
                        context: context,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email?';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {},
                      ),
                      const SizedBox(height: 20),
                      _buildTextFormField(
                        controller: _messageController,
                        label: 'Message',
                        icon: Icons.message_outlined,
                        minLines: 1,
                        maxLines: 6,
                        context: context,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Message?'
                            : null,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleSubmit(context),
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _handleSubmit(context),
                          style:
                              ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 18,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ).copyWith(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith((states) {
                                      if (states.contains(
                                        WidgetState.pressed,
                                      )) {
                                        return const Color(
                                          0xFF0A4A8E,
                                        ).withAlpha((0.7 * 255).round());
                                      }
                                      if (states.contains(
                                        WidgetState.hovered,
                                      )) {
                                        return const Color(
                                          0xFF0A4A8E,
                                        ).withAlpha((0.6 * 255).round());
                                      }
                                      return const Color(
                                        0xFF0A4A8E,
                                      ).withAlpha((0.5 * 255).round());
                                    }),
                              ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF0A4A8E).withAlpha(0),
                                  const Color(0xFF001529).withAlpha(0),
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.send_rounded,
                                  size: 20,
                                  color: Colors.white.withAlpha(
                                    (0.95 * 255).round(),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Send',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.5,
                                    color: Colors.white.withAlpha(
                                      (0.95 * 255).round(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
}
