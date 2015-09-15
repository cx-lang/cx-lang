Expression
  = first:AssignmentExpression rest:(__ "," __ AssignmentExpression)* {
      return rest.length ? append({ type: "expression", kind: "sequence", expressions: buildList(first, rest, 3) }) : first;
    }
