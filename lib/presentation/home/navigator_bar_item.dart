part of 'home_view.dart';

class NavigatorBarItem extends StatefulWidget {
  NavigatorBarItem({super.key, 
    required this.title,
    required this.icon,
    required this.isChoose,
    required this.onTap,
  });

  final String title;

  final IconData icon;

  final bool isChoose;

  final VoidCallback onTap;

  @override
  State<NavigatorBarItem> createState() => _NavigatorBarItemState();
}

class _NavigatorBarItemState extends State<NavigatorBarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.isChoose ? AppColors.blueLight : Colors.white
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              color: widget.isChoose ? AppColors.blueDark : AppColors.blueGray,
              size: 24
            ),
            const SizedBox(width: 8,),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: widget.isChoose ? AppColors.blueDark : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}