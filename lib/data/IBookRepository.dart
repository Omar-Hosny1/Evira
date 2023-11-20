abstract class IBookRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getOne(int id);
  Future<void> insert(T book);
  Future<void> update(T book);
  Future<void> delete(int id);
}