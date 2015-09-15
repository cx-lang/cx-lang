UnaryExpression
  = operator:UpdateOperator __ right:Expression {
      return append({ type: "expression", kind: "update", operator: operator, right: right });
    }
  / operator:UnaryOperator __ right:Expression {
      return append({ type: "expression", kind: "unary", operator: operator, right: right });
    }

UnaryOperator
  = $DeleteToken
  / $TypeofToken
  / "+"
  / "-"
  / "~"
  / "!"
  / "&"
  / "*"
