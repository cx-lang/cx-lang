MemberExpression
  = GenericName
  / first:(
        PrimaryExpression
      / NewToken __ callee:MemberExpression __ args:CallArguments {
          return append({ type: "new", callee: callee, arguments: args });
        }
    )
    rest:(
        __ "[" __ property:Expression __ "]" {
          property.computed = true;
          return property;
        }
      / __ "." __ property:Identifier {
          property.computed = false;
          return property;
        }
    )*
    {
      return first.concat(rest);
    }
