import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:manga_nih/blocs/blocs.dart';
import 'package:manga_nih/blocs/event_states/event_states.dart';
import 'package:manga_nih/models/models.dart';
import 'package:manga_nih/ui/widgets/widgets.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  late FeedbackBloc _feedbackBloc;

  @override
  void initState() {
    _feedbackBloc = BlocProvider.of(context);

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();

    super.dispose();
  }

  void _submitAction() {
    if (_key.currentState!.validate()) {
      String title = _titleController.text.trim();
      String body = _bodyController.text.trim();

      FeedbackModel feedback = FeedbackModel(title: title, body: body);
      _feedbackBloc.add(FeedbackSubmit(feedback: feedback));

      FocusScope.of(context).unfocus();
    }
  }

  void _feedbackListener(BuildContext context, FeedbackState state) {
    if (state is FeedbackSubmitSuccess) {
      SnackbarModel.custom(false, 'Thank you for the feedback');

      _titleController.clear();
      _bodyController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackBloc, FeedbackState>(
      listener: _feedbackListener,
      child: Scaffold(
        appBar: AppBar(title: Text('Feedback')),
        body: Form(
          key: _key,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: [
              InputField(
                tag: 'Title',
                hintText: 'New feature',
                controller: _titleController,
                errorText: null,
              ),
              const SizedBox(height: 20.0),
              InputField(
                tag: 'Your feedback',
                hintText: 'Please add something',
                maxLines: 7,
                controller: _bodyController,
                errorText: null,
              ),
              const SizedBox(height: 40.0),
              BlocBuilder<FeedbackBloc, FeedbackState>(
                builder: (context, state) {
                  if (state is FeedbackLoading) {
                    return PrimaryButton.loading();
                  }

                  return PrimaryButton(
                    label: 'Submit',
                    onTap: _submitAction,
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
