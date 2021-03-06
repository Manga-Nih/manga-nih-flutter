import 'package:flutter/material.dart';

class RegionFlag extends StatelessWidget {
  final String pathFlag;
  final String label;
  final VoidCallback onTap;

  const RegionFlag({
    Key? key,
    required this.pathFlag,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade300, width: 1.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: Offset(1, 2),
              )
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: Column(
              children: [
                SizedBox(
                  width: screenSize.width * 0.25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      pathFlag,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
