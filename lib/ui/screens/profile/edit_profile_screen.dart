import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/configs/pallette.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  late UserBloc _userBloc;
  File? _image;

  @override
  void initState() {
    _userBloc = BlocProvider.of(context);

    UserState state = _userBloc.state;
    if (state is UserFetchSuccess) {
      _nameController.text = state.user.displayName!;
    }

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  Future<void> _editPictureAction() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() => _image = File(result.files.single.path!));
    }
  }

  void _saveAction() {
    if (_key.currentState!.validate()) {
      String name = _nameController.text.trim();

      _userBloc.add(UserUpdateProfile(name: name, image: _image));

      FocusScope.of(context).unfocus();
    }
  }

  void _userListener(BuildContext context, UserState state) {
    if (state is UserFetchSuccess) {
      SnackbarModel.custom(false, 'Success update profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: _userListener,
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Profile')),
        body: Form(
          key: _key,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: [
              Stack(
                children: [
                  Center(
                    child: BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UserFetchSuccess) {
                          return Avatar.network(
                            radius: 70.0,
                            image: state.user.photoURL,
                          );
                        }

                        return Avatar(radius: 70.0, image: _image);
                      },
                    ),
                  ),
                  Positioned(
                    right: 45.0,
                    child: MaterialButton(
                      onPressed: _editPictureAction,
                      color: Pallette.gradientStartColor,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10.0),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 22.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              InputField(
                controller: _nameController,
                tag: 'Name',
                hintText: 'Your name',
              ),
              const SizedBox(height: 20.0),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoading) {
                    return const PrimaryButton.loading();
                  }

                  return PrimaryButton(
                    label: 'Save',
                    onTap: _saveAction,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
