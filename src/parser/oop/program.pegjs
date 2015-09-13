Program
= __ elements:NamespaceElements EOF {
    return append({
      type: 'program',
      api: __CX_API__,
      elements: elements
    });
  }
