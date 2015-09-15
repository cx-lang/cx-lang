ArrayLiteral "array"
  = "[" __ "]" {
      return append({ type: 'array', elements: [] });
    }
  / "[" __ elements:ElementList __ "]" {
      return append({ type: "array", elements: elements });
    }

ElementList
  = first:AssignmentExpression rest:(__ "," __ element:AssignmentExpression)* __ ","? {
    return buildList(first, rest, 3);
  }
