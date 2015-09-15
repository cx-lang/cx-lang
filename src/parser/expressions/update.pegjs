UpdateExpression
  = left:Expression __ operator:UpdateOperator {
      return append({ type: "expression", kind: "update", expression: left, operator: operator });
    }
  / CallExpression
  / NewExpression

UpdateOperator
  = "++"
  / "--"
