import 'package:flutter/material.dart';
import 'package:task_app/helpers/notification_helper.dart';
import '../helpers/color_helper.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DetailTaskPage extends StatefulWidget {
  final task;
  const DetailTaskPage({super.key, this.task});

  @override
  State<DetailTaskPage> createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        decoration: BoxDecoration(gradient: ColorHelper.gradiant),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Détail Tache : ${widget.task['title']}".toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(
              height: 60,
            ),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius:
              const BorderRadius.all(Radius.circular(5))),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            const SizedBox(height: 20,),
            Row(
             children: [
               Text(widget.task['title'].toString().toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),)
             ],
           ),
            AutoSizeText(
              minFontSize: 18,
              widget.task['description'],
              style:  const TextStyle(fontSize: 18, color: Colors.white70),
              maxLines: 10,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator. pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Icon(Icons.arrow_circle_left, color: Colors.white,),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Icon(Icons.edit, color: Colors.yellow,),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      headerAnimationLoop: false,
                      dialogType: DialogType.noHeader,
                      body: const Center(child: Text(
                        'Voulez-vous supprimé cette tâches.',
                        style: TextStyle(fontSize: 20),
                      ),),
                      // btnCancel: const Text("Non"),
                      btnCancelText: "Non",
                      btnCancelColor: Colors.black,
                      btnOkColor: Colors.red,
                      btnOkText: "Oui",
                      btnCancelOnPress: () {
                        print("object");
                      },
                      btnOkOnPress: () {
                        NotificationHelper.showNotification('${'Tâche "'+widget.task['title']}" supprimée avec succès.');
                      },
                    ).show();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: const Icon(Icons.delete_outline_outlined, color: Colors.red,),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,)
          ],
        ),
        )
          ],
        ),
      ),
    );
  }
}
