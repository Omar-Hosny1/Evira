import 'package:evira/data/data-sources/VirtualBooksDB.dart';
import 'package:evira/data/models/book.dart';
import 'package:evira/data/repositories/book-repo.dart';

class BooksController {
  BookRepository _bookRepository = BookRepository(VirtualDB());
  
  
  Future<List<Book>> getAllBooks() {
    return _bookRepository.getAll();
  }

  Future<void> addBook(Book book) {
    return _bookRepository.insert(book);
  }

  Future<void> removeBook(int id) {
    return _bookRepository.delete(id);
  }
}