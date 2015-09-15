PrimaryExpression
  = ContextLiteral
  / GenericName
  / Literal
  / ArrayLiteral
  / "(" __ expression:Expression __ ")" { return expression; }
