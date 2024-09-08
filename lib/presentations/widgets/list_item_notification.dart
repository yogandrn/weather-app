// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:weather_app/presentations/themes/colors.dart';
import 'package:weather_app/presentations/themes/textstyles.dart';

class ListItemNotification extends StatefulWidget {
  final bool isRead;
  final String message, iconAsset;
  final String date;

  const ListItemNotification(
      {super.key,
      required this.message,
      required this.iconAsset,
      required this.date,
      this.isRead = false});

  @override
  State<ListItemNotification> createState() => _ListItemNotificationState();
}

class _ListItemNotificationState extends State<ListItemNotification> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: white,
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: widget.isRead ? white : primary.withOpacity(0.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                widget.iconAsset,
                width: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Text(
                        widget.date,
                        maxLines: 1,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: textbodyStyle.copyWith(
                          height: 1.65,
                          fontSize: 13.6,
                          fontWeight:
                              widget.isRead ? FontWeight.w500 : FontWeight.w600,
                          color: darkGrey,
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        widget.message,
                        maxLines: isExpanded ? 20 : 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: textbodyStyle.copyWith(
                          height: 1.25,
                          fontSize: 14,
                          fontWeight:
                              widget.isRead ? FontWeight.w500 : FontWeight.w600,
                          color: black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: darkGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
