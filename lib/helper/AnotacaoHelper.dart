import 'package:app_minhas_anotacoes/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {

  // static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();

  static final String nomeTabela= "anotacao";

  Database? _db;


  // AnotacaoHelper._internal(){}

  get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await inicializarDB();
      return _db;
    }
  }

  inicializarDB() async {
    final caminhoDB = await getDatabasesPath();
    final localBancoDados = join(caminhoDB, "bd_minhas_anotacoes.db");

    var db = await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async{
    String sql = "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data VARCHAR)";
    await db.execute(sql);
}

  Future<int> salvarAnotacao(Anotacao anotacao) async{
    var bancoDados = await  db;
    int id = await bancoDados.insert(nomeTabela, anotacao.toMap());
    return id;
  }

}