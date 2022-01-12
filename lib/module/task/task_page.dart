import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qinglong_app/base/base_state_widget.dart';
import 'package:qinglong_app/module/task/task_viewmodel.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return BaseStateWidget<TaskViewModel>(
      builder: (context, model, child) {
        return RefreshIndicator(
          onRefresh: () async {
            return Future.delayed(Duration(seconds: 1), () {});
          },
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              vertical: 15,
            ),
            itemBuilder: (context, index) {
              return TaskItemCell();
            },
            itemCount: model.list.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10,
              );
            },
          ),
        );
      },
      model: taskProvider,
      onReady: (viewModel) {
        viewModel.loadData();
      },
    );
  }
}

class TaskItemCell extends StatelessWidget {
  const TaskItemCell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: const ValueKey(0),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        dragDismissible: false,
        children: [
          SlidableAction(
            flex: 1,
            icon: CupertinoIcons.memories,
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF0F77FE),
            onPressed: (BuildContext context) {},
          ),
          SlidableAction(
            flex: 1,
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: CupertinoIcons.clock_fill,
            onPressed: (BuildContext context) {},
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        extentRatio: 0.15,
        children: [
          SlidableAction(
            backgroundColor: Colors.cyan,
            flex: 1,
            onPressed: (_) {},
            foregroundColor: Colors.white,
            icon: CupertinoIcons.ellipsis,
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  "东东农场",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                Spacer(),
                Text("2020/12/12 12:23"),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "12/12/12",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
