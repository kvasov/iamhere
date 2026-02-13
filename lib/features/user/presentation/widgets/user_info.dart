import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iamhere/shared/utils/photo.dart';

class UserInfo extends StatelessWidget {
  final String id;
  final String name;
  final String photoPath;
  final String profileId;

  const UserInfo({
    super.key,
    required this.id,
    required this.name,
    required this.photoPath,
    required this.profileId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(8.0),
      child: Row(
        mainAxisAlignment: .start,
        crossAxisAlignment: .center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(photoUrl(photoPath)),
            radius: 30,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(name),
              if (profileId == id)
                Text('Это вы', style: TextStyle(color: Colors.green))
              else
                GFButton(
                  text: "Подписаться",
                  icon: const Icon(Icons.person_add, size: 16, color: Colors.white),
                  onPressed: () {

                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}