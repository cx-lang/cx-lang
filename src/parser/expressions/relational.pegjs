RelationalExpression
  = left:Expression __ operator:RelationalOperator __ right:Expression {
      return append({ type: "expression", kind: "relational", left: left, operator: operator, right: right });
    }

RelationalOperator
  = $AsToken
  / $InstanceofToken
  / $InToken
  / $OfToken
  / "*"
  / "/"
  / "%"
  / "+"
  / "-"
  / "<<"
  / ">>"
  / "<="
  / ">="
  / "<"
  / ">"
  / "=="
  / "!="
  / "&"
  / "^"
  / "|"
  / "&&"
  / "||"
  / "??"
