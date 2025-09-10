/// A collection of reusable application functions.
class AppFunctions {
  /// Searches a list of items [list] based on a search query [query].
  ///
  /// This is a generic function that can search any list of type [T].
  /// The [fieldExtractor] function is used to get the string value from an item
  /// that should be used for the comparison.
  ///
  /// Returns a new list containing only the items that match the query.
  /// If the query is empty, it returns an empty list.
  static List<T> searchList<T>(
    String query,
    List<T> list,
    String? Function(T item) fieldExtractor,
  ) {
    if (query.isEmpty) {
      return list;
    }

    final lowerCaseQuery = query.toLowerCase();
    return list.where((item) {
      final fieldValue = fieldExtractor(item)?.toLowerCase();
      return fieldValue?.contains(lowerCaseQuery) ?? false;
    }).toList();
  }
}

// void searchCustomerResult(String val) {
//   filterendList.value = AppFunctions.searchList(
//     val,
//     contacts,
//     (item) => item.custName,
//   );
// }
