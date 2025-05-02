import 'package:flutter/material.dart';
import 'package:task_app/back_office/list_task_page.dart';
import 'package:task_app/helpers/notification_helper.dart';
import 'package:task_app/models/enums/ResponseStatus.dart';
import 'package:task_app/services/task_service.dart';
import '../helpers/color_helper.dart';
import '../widgets/add_task_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AddOrEditTask extends StatefulWidget {
  const AddOrEditTask({super.key});

  @override
  State<AddOrEditTask> createState() => _AddOrEditTaskState();
}

class _AddOrEditTaskState extends State<AddOrEditTask> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ColorHelper.gradiant),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: const Center(child: const Text(
                "Ajouter une Tâches",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),)
            ),
            const SizedBox(
              height: 60,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child:
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  AddTaskTextField(controller: _title, hintText: "Titre",labelText: "Titre",maxLine: 1,),
                  const SizedBox(
                    height: 8,
                  ),
                   AddTaskTextField(controller: _description, hintText: "Description",labelText: "Description",maxLine: 3,),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator. pop(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 100,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Icon(Icons.arrow_circle_left, color: Colors.yellow,),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () async {
                          if(!_isLoading){
                            if(_title.text.isEmpty || _description.text.isEmpty){
                              NotificationHelper.showNotification('Veuillez renseigner les deux champs svp.');
                            }else{
                              var data = {
                                'title': _title.text,
                                'description': _description.text
                              };
                              var response = await TaskService.addTask(data);
                              if(response['status'] == ResponseStatus.OK.name){
                                NotificationHelper.showNotification(response['message']);
                                Navigator. push<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) => const ListTaskPage(),
                                  ),
                                );                              }else{
                                NotificationHelper.showNotification(status: ResponseStatus.EXCEPTION.name,response['message']);
                              }
                            }
                          }else{
                            NotificationHelper.showNotification(status: ResponseStatus.EXCEPTION.name,'Ajout tâche en cours');
                          }

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 100,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: _isLoading ? Colors.black.withOpacity(0.2) :  Colors.black,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Icon(Icons.save, color: Colors.yellow,),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
