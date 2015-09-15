GenericName
  = value:Pathname __ args:TemplateArguments {
      return append({
        type: 'generic',
        value: value,
        arguments: args
      });
    }

TemplateArguments
  = "<" __ ">" { return []; }
  / "<" __ first:TypeName rest:(__ "," __ TypeName)* __ ">" {
      return buildList(first, rest, 3);
    }

GenericArguments
  = "<" __ first:GenericArgument rest:(__ "," __ GenericArgument)* __ ">" {
      return buildList(first, rest, 3);
    }

GenericArgument
  = identifier:Variable value:(__ "=" __ TypeName)? {
      return append({
        type: "typedef",
        identifier: identifier,
        value: value ? value[3] : null
      });
    }
