import '../imports.dart';

class CustomCard extends StatelessWidget {
  final double radius;
  final double? width, height;
  final Widget? child;
  final EdgeInsets margin, padding;

  const CustomCard({
    Key? key,
    this.width,
    this.radius = 10.0,
    this.height,
    this.child,
    this.margin = const EdgeInsets.all(8.0),
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(
              0.4,
            ),
            blurRadius: 4.0,
            spreadRadius: 2.0,
          )
        ],
      ),
      child: child,
    );
  }
}