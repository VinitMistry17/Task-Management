import 'package:cloud_firestore/cloud_firestore.dart';

import 'task_model.dart';

// Har user ke tasks alag: users/{uid}/tasks/{taskId}
class TaskRepository {
  TaskRepository(this._firestore, this._uid);

  final FirebaseFirestore _firestore;
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _tasks =>
      _firestore.collection('users').doc(_uid).collection('tasks');

  // Realtime stream, due date ke hisaab se earliest -> latest
  Stream<List<Task>> watchTasks() {
    return _tasks.orderBy('dueDate').snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Task.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> addTask(Task task) => _tasks.add(task.toMap());

  Future<void> updateTask(Task task) =>
      _tasks.doc(task.id).update(task.toMap());

  Future<void> deleteTask(String id) => _tasks.doc(id).delete();

  Future<void> setCompleted(String id, bool isCompleted) =>
      _tasks.doc(id).update({'isCompleted': isCompleted});
}