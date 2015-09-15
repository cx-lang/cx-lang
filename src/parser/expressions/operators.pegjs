OperatorExpression
  = "(" __ typename:TypeName __ ")" __ expression:Expression {
      return append({ type: "expression", kind: "cast", returns: typename, expression: expression });
    }
  / TernaryExpression
  / RelationalExpression
  / UnaryExpression
  / UpdateExpression

TernaryExpression
  = condition:Expression __ "?" __ left:Expression right:(__ ":" __ Expression)? {
      return append({
        type: "expression",
        kind: "ternary",
        condition: condition,
        consequent: left,
        alternate: right ? right[3] : null
      });
    }
