import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';





class PracticSetPage extends StatefulWidget {
  const PracticSetPage({Key? key}) : super(key: key);

  @override
  State<PracticSetPage> createState() => _PracticSetPageState();
}

class _PracticSetPageState extends State<PracticSetPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  addUser(){
    String name = nameController.text.trim();
    String email = emailController.text.trim();

    if(name != "" && email != ""){
        Map<String,dynamic> NewUser = {
              'name':name,
              'email':email
        };

        _firestore.collection("somad").add(NewUser);
        log("User Add");
    }
  }

  userDal(){
    _firestore.collection("somad").doc('id').delete();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Practic Set Page"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter Your Name'
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter Your Email'
                ),
              ),
              ElevatedButton(onPressed: (){
                addUser();
              }, child: Text("Data Add")),
              SizedBox(
                height: 20,
              ),

              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection("somad").snapshots(),
                builder: ((context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.active){
                      if(snapshot.hasData && snapshot.data != null){
                        return Expanded(child: 
                        ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: ((context, index) {
                             Map<String,dynamic> strData = snapshot.data!.docs[index].data() as Map<String,dynamic>;
                          
                            return ListTile(
                              title: Text(strData["name"]),
                              subtitle: Text(strData["email"]),
                              trailing: IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.red,)),
                              onTap: (){

                              },
                            );
                          }))
                        );
                      }
                     
                  }
                   return Text("");
                }))
              
            ],
          ),
        ),
      ),
    );
  }
}