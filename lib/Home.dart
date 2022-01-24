import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  _exibirTelaCadastro(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Adicionar anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Digite o título",
                  ),
                ),
                TextField(
                  controller: _descricaoController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Descrição",
                    hintText: "Digite a descrição",
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: (){Navigator.pop(context);},
                child: Text("CANCELAR"),
              ),
              TextButton(
                onPressed: (){Navigator.pop(context);},
                child: Text("SALVAR"),
              ),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas anotações"),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _exibirTelaCadastro();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
