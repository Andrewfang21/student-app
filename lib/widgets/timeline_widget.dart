import "package:flutter/material.dart";
import "package:timeline_list/timeline.dart";

class TimelineWidget extends StatelessWidget {
  final List<dynamic> items;
  final IndexedTimelineModelBuilder builder;

  const TimelineWidget({
    @required this.items,
    @required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Timeline.builder(
      itemBuilder: builder,
      itemCount: items.length,
      physics: ClampingScrollPhysics(),
      position: TimelinePosition.Left,
    );
  }
}

class TimelineCard extends StatelessWidget {
  final Function onTapHandler;
  final Function onLongPressHandler;
  final Widget child;

  const TimelineCard({
    @required this.onTapHandler,
    @required this.onLongPressHandler,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onTapHandler,
        onLongPress: onLongPressHandler,
        child: Container(
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
