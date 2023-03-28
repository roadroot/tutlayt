bool equal(Iterable<Object>? o1, Iterable<Object>? o2) {
  if (o1 == null) {
    return o1 == o2;
  }
  if (o2 == null) {
    return o2 == o1;
  }
  if (o1.length != o2.length) {
    return false;
  }
  for (var i = 0; i < o1.length; i++) {
    Object e1 = o1.elementAt(i);
    Object e2 = o2.elementAt(i);
    if (e1 is Iterable<Object> && e2 is Iterable<Object>) {
      if (!equal(e1, e2)) {
        return false;
      }
    } else if (e1 != e2) {
      return false;
    }
  }
  return true;
}

notEqual(Iterable<Object>? o1, Iterable<Object>? o2) => !equal(o1, o2);

int hash(Iterable<Object> o) {
  int hashCode = 0;
  for (var element in o) {
    if (element is Iterable<Object>) {
      hashCode = hashCode * 31 + hash(element);
    } else {
      hashCode = hashCode * 31 + element.hashCode;
    }
  }
  return hashCode;
}
