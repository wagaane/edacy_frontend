import 'package:flutter/material.dart';
import 'package:task_app/auth/login_page.dart';
import 'package:task_app/helpers/color_helper.dart';
import 'package:task_app/helpers/icon_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/helpers/notification_helper.dart';
import 'package:task_app/models/enums/ResponseStatus.dart';
import 'package:task_app/models/task_model.dart';
import 'package:task_app/services/task_service.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../widgets/add_task_text_field.dart';

class ListTaskPage extends StatefulWidget {
  const ListTaskPage({super.key});

  @override
  State<ListTaskPage> createState() => _ListTaskPageState();
}

class _ListTaskPageState extends State<ListTaskPage> {
  late List<TaskModel> tasks = [];
  final _title = TextEditingController();
  final _description = TextEditingController();
  bool _isLoading = true;
  int size = 10;
  int page = 0;
  int totalElements = 0;
  int totalPages = 0;
  int currentPage = 0;
  final controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListTasks();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        if(totalPages > 1){
          setState(() {
            isMore = false;
          });
        }
        refresh();
      }
    });
  }

  _getListTasks(
      {page = 0, size = 10, filter = '', title = '', description = ''}) async {
    var response = await TaskService.listTasks(
        page: page, size: size, description: '', title: '');
    setState(() {
      tasks.addAll(TaskModel.fromList(response['payload']));
      size = response['metadata']['size'];
      page = response['metadata']['number'];
      page = response['metadata']['totalElements'];
      totalPages = response['metadata']['totalPages'];
      totalElements = response['metadata']['totalElements'];
      _isLoading = false;
    });
  }

  bool isMore = false;
  Future refresh() async {
    print(totalPages);
    if ((tasks.length == totalElements) && (totalPages >= 1)) {
      setState(() {
        isMore = false;
      });
      print(isMore);
    } else {
      setState(() {
        isMore = true;
      });
      if (currentPage < (totalPages - 1)) {
        setState(() {
          currentPage = currentPage + 1;
        });
        _getListTasks(page: currentPage, size: size);
      }
    }
  }

  _sizeSelected(String type) {
    return type == 'selected'
        ? tasks
            .where(
              (element) => element.selected == true,
            )
            .length
        : tasks
            .where(
              (element) => element.selected == false,
            )
            .length;
  }

  bool _isAllSelected = false;
  var data = {'title': '', 'description': '', 'id': 0};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            _sizeSelected('selected') == 0
                ? _addOrEditTask(context, data)
                : _deleteListTasks(context);
          },
          child: Icon(
            _sizeSelected('selected') == 0
                ? Icons.add
                : Icons.delete_outline_outlined,
            color: Colors.yellow,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(gradient: ColorHelper.gradiant),
          child: !_isLoading
              ? Column(children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text(
                            "Mes taches",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              tasks.isNotEmpty ?
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _isAllSelected = !_isAllSelected;
                                  });
                                  List<TaskModel> task_ = [];
                                  for (var element in tasks) {
                                    element.selected = !element.selected;
                                    task_.add(element);
                                  }
                                  setState(() {
                                    tasks = task_;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100))),
                                    child: Row(
                                      children: [
                                        const Text(
                                          "select. tâches",
                                          style:
                                              TextStyle(color: Colors.yellow),
                                        ),
                                        const SizedBox(width: 5,),
                                        Icon(
                                          _isAllSelected == false ? Icons.check_circle_outline : Icons.check_circle_rounded,
                                          color: Colors.yellow,
                                        )
                                      ],
                                    ),
                                  ), //
                                ),
                              ):Center(),
                              GestureDetector(
                                onTap: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.clear();
                                  NotificationHelper.showNotification(
                                      'Dèconnexion réussie.');
                                  Navigator.push<void>(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          const LoginPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100))),
                                    child: IconHelper.logoutIcon,
                                  ), //
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  tasks.isEmpty
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 200,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: const BorderRadius.all(
                                      Radius.elliptical(10, 10))),
                              child: const Center(
                                child: Text(
                                  "Liste des tâches vide !!",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        )
                      : Expanded(
                          child: RefreshIndicator(
                            onRefresh: refresh,
                            child: ListView.builder(
                              controller: controller,
                              itemCount: tasks.length + 1,
                              itemBuilder: (context, index) {
                                if (index < tasks.length) {
                                  final task = tasks[index];
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10))),
                                          child: ListTile(
                                            title: Text(
                                              task.title,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            subtitle: AutoSizeText(
                                              task.description,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white70),
                                              maxLines: 1,
                                            ),
                                            leading: const Icon(
                                              Icons.task_alt,
                                              color: Colors.white,
                                            ),
                                            onTap: () {
                                              NotificationHelper
                                                  .showNotification(
                                                      "appuyez longuement");
                                            },
                                            onLongPress: () {
                                              setState(() {
                                                data = {
                                                  'title': task.title,
                                                  'description':
                                                      task.description,
                                                  'id': task.id
                                                };
                                              });
                                              _showTask(context, task);
                                            },
                                            trailing: IconButton(
                                                onPressed: () {
                                                  var value = tasks
                                                      .where(
                                                        (element) =>
                                                            element.id ==
                                                            task.id,
                                                      )
                                                      .first;
                                                  var value_ = value;
                                                  value_.selected =
                                                      !value.selected;

                                                  setState(() {
                                                    tasks[tasks.indexOf(
                                                        value)] = value_;
                                                  });
                                                },
                                                icon: task.selected
                                                    ? const Icon(
                                                        Icons.check_box,
                                                        color: Colors.yellow,
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .check_box_outline_blank,
                                                        color: Colors.yellow,
                                                      )),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  );
                                } else {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: isMore
                                            ? const CircularProgressIndicator(
                                                color: Colors.black,
                                              )
                                            : const Text(
                                                "fin de liste",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      )
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                        )
                ])
              : const Center(
                  child: const CircularProgressIndicator(
                  color: Colors.black,
                )),
        ));
  }

  Future<dynamic> _showTask(BuildContext context, TaskModel task) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.6),
          title: Text(
            task.title.toUpperCase(),
            style: const TextStyle(color: Colors.white70),
          ),
          content: SizedBox(
            // height: 200,
            width: MediaQuery.of(context).size.width - 10,
            child: AutoSizeText(
              minFontSize: 18,
              task.description,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              maxLines: 10,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black)),
                    onPressed: () async {
                      var response = await TaskService.deleteTask(task.id);
                      if (response['status'] == ResponseStatus.OK.name) {
                        await _getListTasks();
                        NotificationHelper.showNotification(
                            response['message']);
                        Navigator.pop(context);
                      } else {
                        NotificationHelper.showNotification(response['message'],
                            status: ResponseStatus.EXCEPTION.name);
                        Navigator.pop(context);
                      }
                    },
                    child: const Icon(
                      Icons.delete_outline_outlined,
                      color: Colors.yellow,
                    )),
                const SizedBox(
                  width: 5,
                ),
                TextButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black)),
                    onPressed: () {
                      _addOrEditTask(context, task, isEditing: true);
                    },
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Colors.yellow,
                    )),
                const SizedBox(
                  width: 5,
                ),
                TextButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black)),
                    onPressed: () {
                      // Do something
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.yellow,
                    )),
              ],
            )
          ],
        );
      },
    );
  }

  Future<dynamic> _deleteListTasks(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.6),
          title: Text(
            "Suppression tâche${_sizeSelected('selected') > 1 ? 's' : ''}",
            style: const TextStyle(color: Colors.yellow),
          ),
          content: SizedBox(
            // height: 200,
            width: MediaQuery.of(context).size.width - 10,
            child: AutoSizeText(
              minFontSize: 18,
              "${_sizeSelected('selected')} tâche${_sizeSelected('selected') > 1 ? 's seront supprimées.' : ' est supprimée.'}",
              style: const TextStyle(fontSize: 18, color: Colors.white),
              maxLines: 10,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black)),
                    onPressed: () {
                      // Do something
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.yellow,
                    )),
                const SizedBox(
                  width: 5,
                ),
                TextButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black)),
                    onPressed: () async {
                      List<int> taskIds = [];
                      for (var element in tasks.where((element) => element.selected == true)) {
                        taskIds.add(element.id);
                      }
                      setState(() {
                        _isLoading = true;
                      });
                      var response = await TaskService.deleteListTask(taskIds);
                      print(response);
                      if(response['status'] == 'OK'){
                        setState(() {
                          _isLoading = false;
                        });
                        setState(() {
                          tasks = [];
                        });
                        _getListTasks();

                        Navigator.pop(context);
                        NotificationHelper.showNotification(response['message']);
                      }else{
                        setState(() {
                          _isLoading = false;
                        });
                        NotificationHelper.showNotification(response['data']['message'], status: ResponseStatus.EXCEPTION.name);
                      }
                    },
                    child: const Icon(
                      Icons.delete_outline_outlined,
                      color: Colors.yellow,
                    )),


              ],
            )
          ],
        );
      },
    );
  }

  Future<dynamic> _addOrEditTask(BuildContext context, task,
      {isEditing = false}) {
    if (isEditing) {
      _title.text = task.title;
      _description.text = task.description;
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(0.8),
          title: const Text(
            "Ajouter une tâche",
            style: TextStyle(color: Colors.yellow),
          ),
          content: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width - 10,
              child: Column(
                children: [
                  AddTaskTextField(
                    controller: _title,
                    hintText: "Titre",
                    labelText: "Titre",
                    maxLine: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AddTaskTextField(
                    controller: _description,
                    hintText: "Description",
                    labelText: "Description",
                    maxLine: 3,
                  ),
                ],
              )),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        _title.text = '';
                        _description.text = '';
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.yellow,
                        ),
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () async {
                    if (!_isLoading) {
                      if (_title.text.isEmpty || _description.text.isEmpty) {
                        NotificationHelper.showNotification(
                            'Veuillez renseigner les deux champs svp.');
                      } else {
                        var data = {
                          'title': _title.text,
                          'description': _description.text
                        };
                        var response;
                        if (!isEditing) {
                          response = await TaskService.addTask(data);
                        } else {
                          response = await TaskService.editTask(data, task.id);
                        }
                        print(response);
                        if (response['status'] == ResponseStatus.OK.name) {
                          setState(() {
                            _isLoading = false;
                          });
                          NotificationHelper.showNotification(
                              response['message']);
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const ListTaskPage(),
                            ),
                          );
                        } else {
                          setState(() {
                            _isLoading = false;
                          });
                          NotificationHelper.showNotification(
                              status: ResponseStatus.EXCEPTION.name,
                              response['message']);
                        }
                      }
                    } else {
                      NotificationHelper.showNotification(
                          status: ResponseStatus.EXCEPTION.name,
                          'Ajout tâche en cours');
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.yellow,
                          ),
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Icon(
                        Icons.save,
                        color: Colors.yellow,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
