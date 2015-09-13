NamespaceElements
  = elements:(NamespaceElement __)* {
      return elements && elements.length ? extractList(elements, 0) : [];
    }

NamespaceElement
  = Identifier
  / DecimalDigit
