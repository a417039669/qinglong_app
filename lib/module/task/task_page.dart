import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qinglong_app/base/base_state_widget.dart';
import 'package:qinglong_app/base/theme.dart';
import 'package:qinglong_app/module/task/task_bean.dart';
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
            return model.loadData(false);
          },
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),
            itemBuilder: (context, index) {
              return TaskItemCell(model.list[index]);
            },
            itemCount: model.list.length,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
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

class TaskItemCell extends ConsumerWidget {
  final TaskBean bean;

  const TaskItemCell(this.bean, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              children: [
                Text(
                  bean.name ?? "",
                  maxLines: 1,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: bean.isDisabled == 1 ? Color(0xffF85152) : ref.watch(themeProvider).themeColor.taskTitleColor(),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                bean.status == 1
                    ? const SizedBox.shrink()
                    : const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                const Spacer(),
                Text(
                  "${bean.lastRunningTime ?? "-"}",
                  maxLines: 1,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Color(0xff999999),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              bean.schedule ?? "",
              maxLines: 1,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Color(0xff999999),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
