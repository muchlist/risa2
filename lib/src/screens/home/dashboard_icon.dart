import 'package:flutter/material.dart';

class DashboardIcon extends StatelessWidget {
  final String title;
  final String image;

  const DashboardIcon({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            splashColor: Colors.orange,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Container(
                child: Icon(
                  Icons.dashboard,
                  color: Colors.white,
                ),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(25)),
              ),
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Flexible(
            child: Text(
              title,
              style: TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }
}
