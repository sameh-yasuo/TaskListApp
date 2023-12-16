class Todo {
  int? userId;
  int? id;
  String? title;
  bool? completed = true;

  Todo({
    this.userId,
    this.id,
    required this.title,
    this.completed,
  });

  Todo.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id']; // Convert to string
    title = json['title'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['completed'] = this.completed;
    return data;
  }
}

// Function to create a list of Todo objects from API response
List<Todo> createTodoListFromApi(dynamic apiResponse) {
  // Assume apiResponse is a List<dynamic>
  List<Todo> todoList = [];
  for (var json in apiResponse) {
    Todo todo = Todo.fromJson(json);
    todoList.add(todo);
  }
  return todoList;
}
