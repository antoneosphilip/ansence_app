import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summer_school_app/view_model/block/layout_cubit/layout_states.dart';

import '../../../view/screens/home/home_screen/home_screen.dart';

class LayoutCubit extends Cubit<LayoutStates>
{

  LayoutCubit():super(LayoutInitialState());
  static LayoutCubit get(context)=>BlocProvider.of<LayoutCubit>(context);
  int currIndex=0;
  final List<Widget> pageList = [
    const HomeScreen(),
    const HomeScreen(), // Add another screen here if needed
  ];
  void bottomTap(int index)
  {
    currIndex=index;
    emit(ChangeState());
  }

}