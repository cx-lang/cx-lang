ContextLiteral
  = context:(GlobalToken / InternalToken / SuperToken / ThisToken) {
      return append({ type: "context", kind: context });
    }
