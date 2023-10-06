import 'package:ariapp/app/presentation/voice/widgets/question_background.dart';
import 'package:ariapp/app/presentation/voice/widgets/question_to_clone.dart';
import 'package:flutter/material.dart';

class QuestionScrollableView extends StatelessWidget {
  const QuestionScrollableView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        children: [

          const QuestionToClone(question: '¿Loreos dosd osd masd ismd aios para lode asm  isd ?'),
          const QuestionToClone(question: '¿Lore irsp lors  sdi msds idsm isd mawsiods?'),
          const QuestionToClone(question: '¿Lore sisiw3 iwmekei ei m o mso m,sl oamsd m?'),
          const QuestionToClone(question: '¿Ro slo ikem le jreso oe lsed osl o  sl som kl?'),

          Container(color: Colors.yellow,),
          Container(color: Colors.green,)

        ],
      ),
    );
  }
}
