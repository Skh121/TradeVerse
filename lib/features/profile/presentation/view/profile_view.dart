import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tradeverse/features/profile/domain/entity/profile_entity.dart';
import 'package:tradeverse/features/profile/presentation/view_model/profile_event.dart';
import 'package:tradeverse/features/profile/presentation/view_model/profile_state.dart';
import 'package:tradeverse/features/profile/presentation/view_model/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  File? _selectedAvatar; // To hold the newly selected image file
  String?
  _currentAvatarUrl; // To hold the URL or local path of the current avatar

  @override
  void initState() {
    super.initState();
    // Dispatch LoadProfile event when the page initializes
    context.read<ProfileViewModel>().add(LoadProfile());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  /// Handles picking an image from the gallery.
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedAvatar = File(image.path);
      });
    }
  }

  /// Handles saving the profile changes.
  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileViewModel>().add(
        UpdateProfileEvent(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          bio: _bioController.text,
          avatarFile: _selectedAvatar,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White theme
      appBar: AppBar(
        title: const Text(
          'Profile Information',
          style: TextStyle(color: Colors.black), // Black text for app bar title
        ),
        backgroundColor: Colors.white, // White app bar
        elevation: 0, // No shadow for app bar
        iconTheme: const IconThemeData(color: Colors.black), // Black back arrow
      ),
      body: BlocConsumer<ProfileViewModel, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            // Populate text controllers when profile is loaded
            _firstNameController.text = state.profile.firstName;
            _lastNameController.text = state.profile.lastName;
            _emailController.text = state.profile.user.email;
            _bioController.text = state.profile.bio;
            if (mounted) {
              setState(() {
                _currentAvatarUrl = state.profile.avatar;
              });
            } // Store current avatar URL or local path
            // Clear any previous snackbar messages
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Color.fromARGB(255, 232, 192, 140),
                content: Text('Profile loaded/updated successfully!'),
              ),
            );
          } else if (state is ProfileError) {
            // Show a SnackBar on error
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ProfileLoading && _currentAvatarUrl != null) {
            // Optionally show a temporary message during update
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Saving profile...'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Color.fromARGB(255, 232, 192, 140),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading && _currentAvatarUrl == null) {
            // Show loading indicator only on initial load
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileError && _currentAvatarUrl == null) {
            // Show error message on initial load failure
            return Center(child: Text('Error: ${state.message}'));
          }

          ProfileEntity? profileData;
          if (state is ProfileLoaded) {
            profileData = state.profile;
          }

          // --- THE FIX: Create the ImageProvider based on the avatar path ---
          ImageProvider? avatarImage;
          if (_selectedAvatar != null) {
            avatarImage = FileImage(_selectedAvatar!);
          } else if (_currentAvatarUrl != null &&
              _currentAvatarUrl!.isNotEmpty) {
            // Check if the path is a network URL or a local file path
            if (_currentAvatarUrl!.startsWith('http')) {
              avatarImage = NetworkImage(_currentAvatarUrl!);
            } else {
              avatarImage = FileImage(File(_currentAvatarUrl!));
            }
          }
          // --- END FIX ---

          return SingleChildScrollView(
            key: const Key('profile_scroll_view'), 
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update your personal information and profile settings.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Avatar Section
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor:
                              Colors.grey[200], // Light background for avatar
                          // Use the dynamically created ImageProvider
                          backgroundImage: avatarImage,
                          child:
                              avatarImage == null
                                  ? Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.grey[600],
                                  )
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(
                            Icons.upload_file,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'Change Avatar',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.white, // White button background
                            foregroundColor:
                                Colors.black, // Black text/icon color
                            side: const BorderSide(
                              color: Colors.grey,
                            ), // Grey border
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'JPG, PNG up to 2MB',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ... (rest of your form fields and buttons remain unchanged)
                  // First Name & Last Name
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          key: const Key('firstName_textField'),
                          controller: _firstNameController,
                          labelText: 'First Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          key: const Key('lastName_textField'),
                          controller: _lastNameController,
                          labelText: 'Last Name',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Email
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    readOnly: true, // Email is read-only as per backend
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Bio
                  _buildTextField(
                    key: const Key('bio_textField'),
                    controller: _bioController,
                    labelText: 'Bio',
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                  ),
                  const SizedBox(height: 32),

                  // Subscription Status
                  const Text(
                    'Subscription Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Colors
                              .yellow[100], // Light yellow background for plan
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.yellow[700]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.yellow[800], size: 18),
                        const SizedBox(width: 8),
                        Text(
                          profileData?.subscription?.plan ?? 'No Plan',
                          style: TextStyle(
                            color: Colors.yellow[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save Changes Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      key: const Key('save_changes_button'),
                      onPressed: state is ProfileLoading ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.black, // Black button background
                        foregroundColor: Colors.white, // White text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      child:
                          state is ProfileLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Save Changes',
                                style: TextStyle(fontSize: 16),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper method to build consistent TextFormFields
  Widget _buildTextField({
    Key? key,
    required TextEditingController controller,
    required String labelText,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black), // Black text input
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey), // Grey label
        filled: true,
        fillColor: Colors.white, // White background for text field
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey), // Grey border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue), // Blue focus border
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red), // Red error border
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: validator,
    );
  }
}
