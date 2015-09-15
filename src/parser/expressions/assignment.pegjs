KeyExpression
  = CallExpression
  / NewExpression

AssignmentExpression
  = left:KeyExpression __ operator:AssignmentOperator __ right:AssignmentExpressionLRF {
      return append({ type: "expression", kind: "assignment", left: left, operator: operator, right: right });
    }

// without this fix, PEG.js will report a 'Left recursion' Grammer Error
AssignmentExpressionLRF
  = AssignmentExpression
  / KeyExpression
  / LambdaExpression
  / OperatorExpression

AssignmentOperator
  = "="
  / "?="
  / "+="
  / "-="
  / "*="
  / "/="
  / "%="
  / "&="
  / "|="
  / "^="
  / "<<="
  / ">>="
