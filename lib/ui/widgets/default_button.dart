import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final double? height;
  final String? text;
  final VoidCallback? onTap;
  final double? width;
  final IconData? iconData;
  final double? textSize;
  const DefaultButton({
    super.key,
    this.height,
    this.onTap,
    this.text,
    this.width,
    this.iconData,
    this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).colorScheme;
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: height ?? 60,
        width: width ?? size.width,
        decoration: BoxDecoration(
          color: theme.primary,
          borderRadius: BorderRadius.circular(17),
        ),
        child: iconData != null
            ? Row(
                children: [
                  Text(
                    text ?? '',
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "PlayfairDispalyNormal",
                        fontWeight: FontWeight.w100,
                        fontSize: 10,
                        fontStyle: FontStyle.normal),
                  ),
                  Icon(
                    iconData,
                    color: Colors.white,
                  )
                ],
              )
            : Center(
                child: Text(
                  text ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "PlayfairDispalyNormal",
                    fontWeight: FontWeight.bold,
                    fontSize: textSize ?? 32,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
      ),
    );
  }
}
