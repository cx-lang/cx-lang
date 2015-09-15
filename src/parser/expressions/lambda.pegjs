LambdaExpression
  = kind:FunctionKind __ args:FunctionArguments __ block:Block {
      return append({ type: "lambda", kind: kind, args: args, body: block });
    }
  / LambdaArrowExpression

LambdaArrowExpression
  = arrow:ArrowHead? "=>" __ statement:Statement {
      return append({
        type: "arrow",
        kind: arrow ? arrow[0] : "function",
        args: arrow ? arrow[1] : [],
        body: statement
      });
    }

ArrowHead
  = kind:FunctionKind __ args:FunctionArguments? { return [kind, args || []]; }
  / args:ArrowArguments { return ["function", args]; }

ArrowArguments
  = arg:FunctionArgument { return [arg]; }
  / FunctionArguments
