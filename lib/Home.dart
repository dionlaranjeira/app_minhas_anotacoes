import 'package:app_minhas_anotacoes/helper/AnotacaoHelper.dart';
import 'package:app_minhas_anotacoes/model/Anotacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];

  _exibirTelaCadastro({Anotacao? anotacao}){

    String textoSalvarAtualizar = "";
    if(anotacao == null){
      _tituloController.text = "";
      _descricaoController.text = "";
      textoSalvarAtualizar = "Salvar";
    }else{
      _tituloController.text = anotacao.titulo!;
      _descricaoController.text = anotacao.descricao!;
      textoSalvarAtualizar = "Atualizar";
    }

    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("$textoSalvarAtualizar anotação"),
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
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: (){

                  _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                  Navigator.pop(context);

                  },
                child: Text(textoSalvarAtualizar),
              ),
            ],
          );
        });
  }

  _salvarAtualizarAnotacao({Anotacao? anotacaoSelecionada}) async{

    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    if(anotacaoSelecionada == null){
      Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvarAnotacao(anotacao);
    }else{
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = DateTime.now().toString();

      int resultadoAtualizado = await _db.atualizarAnotacao(anotacaoSelecionada);
    }

    _tituloController.clear();
    _descricaoController.clear();

    _recuperarAnotacoes();

  }

 _formatarData(String data){
   initializeDateFormatting('pt_BR');

   // var fomatador = DateFormat("dd/MM/yyyy");
   var fomatador = DateFormat.yMMMMd("pt_BR");
   DateTime dataConvertida = DateTime.parse(data);
   String dataFomatada = fomatador.format(dataConvertida);

   return dataFomatada;
 }

 _recuperarAnotacoes() async {
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    List<Anotacao> anotacoesTemp = [];
    for(var item in anotacoesRecuperadas){
        Anotacao anotacao = Anotacao.fromMap(item);
        anotacoesTemp.add(anotacao);
    }

    setState(() {
      _anotacoes = anotacoesTemp;
    });
    anotacoesTemp = [];
 }

  _removerAnotacao(int id) async{
    await _db.removerAnotacao(id);
    _recuperarAnotacoes();
  }

 @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas anotações"),
      ),
      body: Column(
        children: [
          Expanded(child: ListView.builder(
              itemCount: _anotacoes.length,
              itemBuilder: (context,index){
                final item = _anotacoes[index];

                return Card(
                  child: ListTile(
                    title: Text(item.titulo!),
                    subtitle: Text(_formatarData(item.data!)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: (){
                            _exibirTelaCadastro(anotacao: item);
                          },
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
                          child: Icon(Icons.edit, color: Colors.blue),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            _removerAnotacao(item.id!);
                          },
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Icon(Icons.delete, color: Colors.red     ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _exibirTelaCadastro();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
