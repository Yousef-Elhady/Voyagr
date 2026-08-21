import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UsingSocialmedia extends StatelessWidget {
  final String icon;
  final VoidCallback ontap;
  final String methodname;
  const UsingSocialmedia({
    super.key,
    required this.icon,
    required this.ontap,
    required this.methodname,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(methodname),
            SizedBox(width: 5),
            SvgPicture.asset(icon, width: 20),
          ],
        ),
      ),
    );
  }
}
