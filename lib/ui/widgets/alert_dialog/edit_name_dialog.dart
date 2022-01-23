import 'package:flutter/material.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/configs/pallette.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class EditNameDialog extends StatefulWidget {
  final String displayName;
  final ValueSetter<String> onSuccess;

  const EditNameDialog({
    Key? key,
    required this.displayName,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _editNameController = TextEditingController();

  @override
  void initState() {
    _editNameController.text = widget.displayName;

    super.initState();
  }

  @override
  void dispose() {
    _editNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text('Edit your name'),
      content: Container(
        width: screenSize.width * 0.7,
        child: Wrap(
          children: [
            Form(
              key: _key,
              child: Column(
                children: [
                  InputField(
                    hintText: 'Name',
                    icon: Icons.edit,
                    controller: _editNameController,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          minWidth: 100.0,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          color: Pallette.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Text(
            'Nah, i like my current name',
            style: TextStyle(color: Colors.white),
          ),
        ),
        MaterialButton(
          onPressed: () {
            if (_key.currentState!.validate()) {
              String name = _editNameController.text.trim();

              widget.onSuccess(name);
              SnackbarModel.custom(false, 'Success update your name');

              Navigator.pop(context);
            }
          },
          minWidth: 70.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Text('Save...'),
        ),
      ],
    );
  }
}
