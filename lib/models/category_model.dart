 class CategoryModel {
  final int id;
  final String name;

  CategoryModel(this.id, this.name);

  factory CategoryModel.fromJson(jsonObject) {
    final int id = jsonObject['id'];
    final String name = jsonObject['name'];
    return CategoryModel(id, name);
  }
}
