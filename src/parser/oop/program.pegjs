Program
= __ elements:NamespaceElements EOF {
    return loc({
      type: 'program',
      api: __CX_API__,
      elements: elements
    });
  }
