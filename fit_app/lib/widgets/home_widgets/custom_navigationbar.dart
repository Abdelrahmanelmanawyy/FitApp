
import 'package:fit_app/constants/color.dart';
import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
    final int currentIndex;
    final Function(int) onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap
    
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 35),
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: AppGradients.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavButton(
            context,
            activeImagePath: "images/profile(black).png",
            inactiveImagePath: "images/profile(white).png" ,
            index: 0 ),
            _buildNavButton(
            context,
            activeImagePath: "images/Pie Chart(black).png",
            inactiveImagePath: "images/Pie Chart(white).png" ,
            index: 1 ),
            _buildNavButton(
            context,
            activeImagePath: "images/Barbell(black).png",
            inactiveImagePath: "images/Barbell(white).png" ,
            index: 2 ),
             _buildNavButton(
            context,
            activeImagePath: "images/Fire(black).png",
            inactiveImagePath: "images/Fire(white).png" ,
            index: 3 ),
             _buildNavButton(
            context,
            activeImagePath: "images/footsteps(black).png",
            inactiveImagePath: "images/footsteps(white).png" ,
            index: 4
            
            
             )
        ],
      ),
    );
  }
   Widget _buildNavButton(
  BuildContext context, {
  required int index,
  required String inactiveImagePath,
  required String activeImagePath,
  
}) {
  final bool isActive = currentIndex == index;
  
  return GestureDetector(
    onTap: () => onTap(index),
    behavior: HitTestBehavior.opaque,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          isActive ? activeImagePath : inactiveImagePath,
          width: 35,  
          height: 35, 
          
        ),
       
        if (isActive)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 35,
            height: 2,
            
          ),
      ],
    ),
  );
}

  }
 