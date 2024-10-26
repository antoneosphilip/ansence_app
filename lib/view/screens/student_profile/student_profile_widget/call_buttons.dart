import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'call_button_item.dart';

class CallButtons extends StatelessWidget {
  const CallButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        SizedBox(width: 16.w,),
        const Expanded(child: CallButton(text: 'الاتصال بالأب')),
        SizedBox(width: 16.w,),
        const Expanded(child: CallButton(text: 'الاتصال بالأم')),
        SizedBox(width: 16.w,),
      ],
    );
  }
}
