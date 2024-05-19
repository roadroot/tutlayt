import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tutlayt/ql.dart';
import 'package:tutlayt/widget/card.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;

  const QuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                question.user.username,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              Text(
                question.creationDate.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Text(
            question.title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          MarkdownWidget(
            data: question.body,
            shrinkWrap: true,
          ),
        ],
      ),
    );
  }
}
