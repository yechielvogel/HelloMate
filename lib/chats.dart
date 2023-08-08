import 'package:flutter/material.dart';

class TileWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const TileWidget({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 10,
          color: Colors.transparent,
        ),
        Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.7), blurRadius: 10),
            ],
          ),
          child: ListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: const Text('Today'),
            leading: const Icon(
              Icons.account_circle_rounded,
              size: 50,
            ),
            iconColor: Colors.yellow,
            textColor: Colors.yellow,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
