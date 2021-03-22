import 'package:flutter/material.dart';

class DashboardIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              child: Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Dashboard",
            style: TextStyle(fontSize: 12),
            overflow: TextOverflow.fade,
          )
        ],
      ),
    );
  }
}
