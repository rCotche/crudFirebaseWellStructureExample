//same name que la collection dans bd dans cloud firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_example_firebase_well_structured/models/todo.dart';

const String TODO_COLLECTION_REF = "todos";

class DatabaseService {
  //instance of cloud firestore
  final _firestore = FirebaseFirestore.instance;
  //reference to particular collection dans la bd
  late final CollectionReference _todosRef;

  DatabaseService() {
    //method collection : get la collection
    //method withConverter : va nous permettre de nous assurer
    //que les données reçus sont conforme à notre schema
    //pas oublier de préciser le type withConverter<Todo>

    //fromFirestore : ce qu'on get de notre base de donnée
    //toFirestore : est appelé avant l'envoie des données

    //_ : on ignore un parametre
    _todosRef = _firestore.collection(TODO_COLLECTION_REF).withConverter<Todo>(
          fromFirestore: (snapshots, _) => Todo.fromJson(
            snapshots.data()!,
          ),
          toFirestore: (todo, _) => todo.toJson(),
        );
  }

  //get todo from the database
  Stream<QuerySnapshot> getTodos() {
    return _todosRef.snapshots();
  }

  void addTodo(Todo todo) {
    _todosRef.add(todo);
  }
}
