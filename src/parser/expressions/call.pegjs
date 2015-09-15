NewExpression
  = MemberExpression
  / NewToken __ callee:NewExpression {
      return append({ type: "new", callee: callee, arguments: [] });
    }

CallExpression
  = first:(
      callee:MemberExpression __ args:CallArguments {
        return append({ type: "call", callee: callee, arguments: args });
      }
    )
    rest:(
        __ args:CallArguments {
          return append({ type: "call", arguments: args });
        }
      / __ "[" __ property:Expression __ "]" {
          property.computed = true;
          return property;
        }
      / __ "." __ property:Identifier {
          property.computed = false;
          return property;
        }
    )* {
      return first.concat(rest);
    }

CallArguments
  = template_args:TemplateArguments? __ "(" __ args:(CallArgumentList __)? ")" {
      return  { template: template_args || [], call: args ? args[0] || [] };
    }

CallArgumentList
  = first:AssignmentExpression rest:(__ "," __ AssignmentExpression)* {
      return buildList(first, rest, 3);
    }
