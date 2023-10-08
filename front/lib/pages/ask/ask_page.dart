import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tutlayt/services/question/question.service.dart';

class AskPage extends StatefulWidget {
  AskPage({super.key});

  final Set<String> tags = {};
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tagController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  State<AskPage> createState() => _AskPageState();
}

class _AskPageState extends State<AskPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width - 300,
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: widget.titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: widget.tagController,
                decoration: const InputDecoration(
                  labelText: 'Tags',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                ],
                onFieldSubmitted: (tag) {
                  setState(() {
                    widget.tags.add(tag);
                  });
                },
              ),
              SizedBox(height: widget.tags.isEmpty ? 0 : 10),
              Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                spacing: 5,
                runSpacing: 5,
                children: widget.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    onDeleted: () {
                      setState(() {
                        widget.tags.remove(tag);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: widget.bodyController,
                decoration: const InputDecoration(
                  labelText: 'Body',
                  border: OutlineInputBorder(),
                ),
                maxLines: 15,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Container()),
                  FilledButton(
                    onPressed: () {
                      if (widget.formKey.currentState!.validate()) {
                        var processing =
                            ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Processing Data'),
                          ),
                        );
                        try {
                          Get.find<QuestionService>().askQuestion(
                            title: widget.titleController.text,
                            body: widget.bodyController.text,
                            tags: widget.tags,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Question Submitted'),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Could not submit question'),
                            ),
                          );
                        } finally {
                          processing.close();
                        }
                      }
                    },
                    child: const Text('Submit Question'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
