abstract class DatabaseService<T> {
  Future<void> create(T item);

  Future<List<T>> getAll();

  Future<void> update(T item);

  Future<void> delete(String id);
}
