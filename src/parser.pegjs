/*
  
  Originally based on the JavaScript pegjs example provided with PEG.js,
  this grammar file is built on work from a variety of pegjs grammar
  file's, mostly created by Futago-za Ryuu. Some grammar is also inspired
  by the ECMA-262 (5th and 6th edition) grammar examples.

  This grammar file has been split into many sections, and each section's
  content has been indented so that editors like Sublime Text can use
  code folding to make it easier for developers to work on this file.

  -----------------------------------------------------------------------

  TODO:

    1) Parsing rules to implement:

        - RegExpLiteral
        - TemplateLiteral

        - AssignmentExpression
        - RelationalExpression
        - UpdateExpression
        - UnaryExpression
        - ArrayExpression

        - InterfaceDefinition
        - EnumDefinition
        - StructDefinition
        - ClassDefinition
        - AbstractDefinition
        - DeclareDefinition

    2) Features to consider adding:

        - https://en.wikipedia.org/wiki/List_comprehension
        - https://babeljs.io/docs/learn-es2015/#symbols
        - Implement C++/C# like pointer's and reference's
        - ES2015 Generators

    3) Rewrite 'ArrowExpression' to be more typed oriented

    4) Add syntax for functional signatures in generics, similar to
       how it is done in C++ templates (e.g. '<T(...Args)>').

  -----------------------------------------------------------------------

  Copyright 2013+ Futago-za Ryuu <futagoza.ryuu@gmail.com>
  This work is release under the MIT License.

  Permission is hereby granted, free of charge, to any person
  obtaining a copy of this software and associated documentation
  files (the "Software"), to deal in the Software without
  restriction, including without limitation the rights to use,
  copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the
  Software is furnished to do so, subject to the following
  conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  OTHER DEALINGS IN THE SOFTWARE.

*/

/* ############### 0 - Utils and Start ############### */

  {
    function extractList ( list, index ) {
      var result = [], i, length = list.length;
      if ( length ) {
        for ( i = 0; i < length; ++i ) {
          result[i] = list[i][index];
        }
      }
      return result;
    }

    function buildList ( head, tail, index ) {
      return tail.length ? [head].concat(extractList(tail, index)) : [head];
    }

    function buildTree ( head, tail, builder ) {
      var result = head, i, length = tail.length;
      if ( length ) {
        for ( i = 0; i < length; ++i ) {
          result = builder(result, tail[i]);
        }
      }
      return result;
    }

    const pegjs$location = location;
    if ( typeof options.filename === 'string' ) {
      location = function ( ) {
        var result = pegjs$location();
        result.filename = options.filename;
        return result;
      };
    }
  }

  start
    = Program

/* ############### 1 - Lexical Grammar ############### */

  /* ~~~~~~~~~~~~~~~ 1.1 - Source characters ~~~~~~~~~~~~~~~ */

    SourceCharacter
      = .

    AlphaCharacter
      = [a-zA-Z]

    DecimalDigit
      = [0-9]

    BinaryDigit
      = "0" / "1"
    
    OctalDigit
      = [0-7]

    HexDigit
      = [0-9a-f]i

  /* ~~~~~~~~~~~~~~~ 1.2 - White space ~~~~~~~~~~~~~~~ */

    WhiteSpace "whitespace"
      = "\t"
      / "\v"
      / "\f"
      / " "
      / "\uFEFF"
      / UnicodeZs

    // Unicode 6+ Separator Space
    UnicodeZs
    = [\u0020\u00A0\u1680\u2000-\u200A\u202F\u205F\u3000]

    LineTerminator
      = [\n\r\u2028\u2029]

    LineTerminatorSequence "end of line"
      = "\n"
      / "\r\n"
      / "\r"
      / "\u2028"
      / "\u2029"

  /* ~~~~~~~~~~~~~~~ 1.3 - Comments ~~~~~~~~~~~~~~~ */

    Comment "comment"
      = MultiLineComment
      / SingleLineComment

    MultiLineComment
      = "/*" (!"*/" SourceCharacter)* "*/"

    MultiLineCommentNoLineTerminator
      = "/*" (!("*/" / LineTerminator) SourceCharacter)* "*/"

    SingleLineComment
      = "//" (!LineTerminator SourceCharacter)*

  /* ~~~~~~~~~~~~~~~ 1.4 - Skipped ~~~~~~~~~~~~~~~ */

    __
      = (WhiteSpace / LineTerminatorSequence / Comment)*

    _
      = (WhiteSpace / MultiLineCommentNoLineTerminator)*

    Elision
      = __ ","

    EOS
      = __ ";"
      / _ SingleLineComment? LineTerminatorSequence
      / _ &"}"
      / __ EOF?

    EOF
      = !.

  /* ~~~~~~~~~~~~~~~ 1.5 - Tokens ~~~~~~~~~~~~~~~ */

    AsToken        = "as"       !IdentifierPart
    AsyncToken     = "async"    !IdentifierPart
    ConstToken     = "const"    !IdentifierPart
    FalseToken     = "false"    !IdentifierPart
    FromToken      = "from"     !IdentifierPart
    FunctionToken  = "function" !IdentifierPart
    ImportToken    = "import"   !IdentifierPart
    InlineToken    = "inline"   !IdentifierPart
    MacroToken     = "macro"    !IdentifierPart
    NewToken       = "new"      !IdentifierPart
    NullToken      = "null"     !IdentifierPart
    //PrivateToken   = "private"  !IdentifierPart
    SuperToken     = "super"    !IdentifierPart
    ThisToken      = "this"     !IdentifierPart
    TrueToken      = "true"     !IdentifierPart
    UsingToken     = "using"    !IdentifierPart

  /* ~~~~~~~~~~~~~~~ 1.6 - Keywords ~~~~~~~~~~~~~~~ */

    Keyword
      = AsToken
      / ConstToken
      / FromToken
      / FunctionToken
      / ImportToken
      / NewToken
      / NullToken
      / UsingToken

      / BooleanKeyword
      / ContextKeyword
      / MethodModifier

    BooleanKeyword
      = TrueToken
      / FalseToken

    ContextKeyword
      = ThisToken
      / SuperToken

    MethodModifier
      = InlineToken
      / MacroToken
      / AsyncToken

  /* ~~~~~~~~~~~~~~~ 1.7 - Identifiers ~~~~~~~~~~~~~~~ */

    Identifier
      = !Keyword name:IdentifierName { return name; }

    IdentifierPath
      = head:Identifier tail:(__ "." __ IdentifierName)+ {
          return { type: "IdentifierPath", value: buildList(head, tail, 3), location: location() };
        }
      / Identifier

    IdentifierName "identifier"
      = value:Word { return { type: "Identifier", value, location: location() }; }

    Word
      = $(IdentifierStart IdentifierPart*)

    IdentifierStart
      = AlphaCharacter
      / "$"
      / "_"
      / "\\" sequence:UnicodeEscapeSequence { return sequence; }

    IdentifierPart
      = IdentifierStart
      / DecimalDigit
      / "\u200C"
      / "\u200D"

/* ############### 2 - Literals ############### */

  /* ~~~~~~~~~~~~~~~ 2.1 - Literal Rule ~~~~~~~~~~~~~~~ */

    Literal
      = PrimaryLiteral
      / NonPrimaryLiteral

    PrimaryLiteral
      = ContextLiteral
      / CharLiteral
      / StringLiteral
      // TemplateLiteral

    NonPrimaryLiteral
      = NullLiteral
      / BooleanLiteral
      / NumericLiteral
      // RegExpLiteral

  /* ~~~~~~~~~~~~~~~ 2.2 - Token based literals ~~~~~~~~~~~~~~~ */

    NullLiteral
      = NullToken { return { type: "NullLiteral", location: location() }; }

    BooleanLiteral
      = value:BooleanKeyword {
          return { type: "BooleanLiteral", value, location: location() };
        }

    ContextLiteral
      = value:ContextKeyword {
          return { type: "ContextLiteral", value, location: location() };
        }

  /* ~~~~~~~~~~~~~~~ 2.3 - Numbers ~~~~~~~~~~~~~~~ */

    NumericLiteral
      = n:Number !(IdentifierStart / DecimalDigit) { return n; }
    
    Number
      = BinaryLiteral
      / OctalLiteral
      / HexLiteral
      / DecimalLiteral

    Integer "int"
      = $DecimalDigit+

    Float "float"
      = f:$(Integer "." Integer) "f"? { return f; }
      / f:$("." Integer) "f"? { return "0" + f; }
      / f:Integer "f" { return f; }

    Exponent "exponent"
      = "e"i sign:[+-]? value:Integer {
          return { value, sign };
        }

    DecimalLiteral
      = FloatLiteral
      / IntegerLiteral

    IntegerLiteral
      = UnsignedInt
      / SignedInt

    UnsignedInt "unsigned int"
      = value:Integer {
          return { type: 'IntegerLiteral', value, location: location() };
        }

    SignedInt "signed int"
      = sign:[+-] value:Integer {
          return { type: 'IntegerLiteral', sign, value, location: location() };
        }

    FloatLiteral
      = sign:[+-]? value:Float exponent:Exponent? {
          return { type: 'FloatLiteral', sign, value, exponent, location: location() };
        }

    BinaryLiteral "binary"
      = value:$("0b"i BinaryDigit+) {
          return { type: "BinaryLiteral", value, location: location() };
         }
    
    OctalLiteral "octal"
      = "0o"i digits:$OctalDigit+ {
          return { type: "OctalLiteral", value: "0o" + digits, location: location() };
         }

    HexLiteral "hex"
      = "0x"i digits:$HexDigit+ {
          return { type: "HexLiteral", value: "0x" + digits, location: location() };
         }

  /* ~~~~~~~~~~~~~~~ 2.4 - Char string ~~~~~~~~~~~~~~~ */

    CharLiteral "char"
      = "'" value:[\u0000-\uFFFF] "'" {
          return { type: "CharLiteral", value, location: location() };
        }

  /* ~~~~~~~~~~~~~~~ 2.5 - Strings ~~~~~~~~~~~~~~~ */

    StringLiteral "string"
      = SingleStringLiteral
      / DoubleStringLiteral

    SingleStringLiteral
      = "'" chars:$SingleStringCharacter* "'" {
          return { type: "SingleStringLiteral", value: JSON.stringify(chars), location: location() };
        }

    DoubleStringLiteral
      = '"' chars:$DoubleStringCharacter* '"' {
          return { type: "DoubleStringLiteral", value: JSON.stringify(chars), location: location() };
        }

    SingleStringCharacter
      = !("'" / "\\" / LineTerminator) SourceCharacter { return text(); }
      / '\\' sequence:("'" / "\\") { return sequence; }

    DoubleStringCharacter
      = !('"' / "\\" / LineTerminator) SourceCharacter { return text(); }
      / "\\" sequence:EscapeSequence { return sequence; }
      / LineContinuation

    EscapeSequence
      = SingleEscapeCharacter
      / NonEscapeCharacter
      / "0" !DecimalDigit { return "\0"; }
      / HexEscapeSequence
      / UnicodeEscapeSequence

    LineContinuation
      = "\\" LineTerminatorSequence { return ""; }

    SingleEscapeCharacter
      = "'"
      / '"'
      / "\\"
      / "b"  { return "\b";   }
      / "f"  { return "\f";   }
      / "n"  { return "\n";   }
      / "r"  { return "\r";   }
      / "t"  { return "\t";   }
      / "v"  { return "\v";   }

    NonEscapeCharacter
      = !(EscapeCharacter / LineTerminator) SourceCharacter { return text(); }

    EscapeCharacter
      = SingleEscapeCharacter
      / DecimalDigit
      / "x"
      / "u"

    HexEscapeSequence
      = "x" digits:$(HexDigit HexDigit) {
          return String.fromCharCode(parseInt(digits, 16));
        }

    UnicodeEscapeSequence
      = "u" digits:$(HexDigit HexDigit HexDigit HexDigit) {
          return String.fromCharCode(parseInt(digits, 16));
        }

/* ############### 3 - Expressions ############### */

  /* ~~~~~~~~~~~~~~~ 3.1 - Base expressions ~~~~~~~~~~~~~~~ */

    Expression
      = BaseExpression
      / TernaryExpression

    WrappedExpression
      = "(" __ expression:Expression __ ")" { return expression; }

    SequenceExpression
      = head:Expression tail:(__ "," __ Expression)+ {
          return { type: "SequenceExpression", expressions: buildList(head, tail, 3), location: location() };
        }
      / Expression

    ConditionalExpression
      = BaseExpression
      / WrappedExpression

    BaseExpression
      = NonPrimaryLiteral
      / AnonymousExpression
      // AssignmentExpression
      // RelationalExpression
      // UpdateExpression
      // UnaryExpression
      / LeftHandSideExpression

    AnonymousExpression
      = LambdaExpression
      / ArrowExpression

    LeftHandSideExpression
      = path:IdentifierPath !MemberProperty { return path; } 
      / CallExpression
      / MemberExpression

    PrimaryExpression
      = PrimaryLiteral
      / Reference
      // ArrayExpression
      / WrappedExpression

  /* ~~~~~~~~~~~~~~~ 3.2 - Reference and type expressions ~~~~~~~~~~~~~~~ */

    Reference
      = GenericName
      / IdentifierPath

    UnionExpression
      = head:Reference tail:(__ "|" __ Reference)+ {
          return { type: "UnionExpression", value: buildList(head, tail, 3), location: location() };
        }

    TypeExpression
      = UnionExpression
      / Reference

    TypeArgument
      = __ ":" __ expression:TypeExpression { return expression; }

  /* ~~~~~~~~~~~~~~~ 3.3 - Generic expressions ~~~~~~~~~~~~~~~ */

    GenericName
      = value:IdentifierPath __ args:GenericArguments {
          return { type: 'GenericName', value, arguments: args, location: location() };
        }

    GenericArguments "generic arguments"
      = "<" __ ">" { return []; }
      / "<" __ head:Reference tail:(__ "," __ Reference)* Elision? __ ">" {
          return buildList(head, tail, 3);
        }

    GenericParameterList
      = "<" __ parameter:GenericParameter __ ">" { return [parameter]; }
      / "<" __ head:GenericParameter tail:(__ "," __ GenericParameter)* Elision? __ ">" {
          return buildList(head, tail, 3);
        }

    GenericParameter "generic argument"
      = name:Identifier value:(__ "=" __ Reference)? {
          return {
            type: "GenericParameter",
            name: name,
            value: value ? value[3] : null,
            location: location()
          };
        }

  /* ~~~~~~~~~~~~~~~ 3.8 - New expressions ~~~~~~~~~~~~~~~ */

    NewExpression
      = NewToken __ callee:Reference __ args:CallArguments {
          return { type: "NewExpression", callee, arguments: args, location: location() };
        }

    WrappedNewExpression
      = "(" __ expression:NewExpression __ ")" { return expression; }

  /* ~~~~~~~~~~~~~~~ 3.9 - Member expressions ~~~~~~~~~~~~~~~ */

    MemberExpression
      = head:MemberElement tail:MemberProperty+ {
          return buildTree(head, tail, (result, element)=>{
            element.object = result;
            return element;
          });
        }
      / MemberElement

    MemberElement
      = PrimaryExpression
      / WrappedNewExpression

    MemberProperty
      = __ "[" __ property:Expression __ "]" {
          return { type: "MemberExpression", property, computed: true };
        }
      / __ "." __ property:IdentifierName {
          return { type: "MemberExpression", property, computed: false };
        }

  /* ~~~~~~~~~~~~~~~ 3.10 - Call expressions ~~~~~~~~~~~~~~~ */

    CallExpression
      = head:(
          callee:MemberExpression __ args:CallArguments {
            return { type: "CallExpression", callee, arguments: args, location: location() };
          }
        )
        tail:(
            __ args:CallArguments {
              return { type: "CallExpression", arguments: args, location: location() };
            }
          / MemberProperty
        )*
        {
          return buildTree(head, tail, (result, element)=>{
            element[element.type === "CallExpression" ? "callee" : "object"] = result;
            return element;
          });
        }

    CallArguments
      = generic_args:GenericArguments? __ "(" __ method_args:(CallArgumentList __)? ")" {
          return  { generic: generic_args || [], call: method_args ? method_args[0] : [] };
        }

    CallArgumentList
      = head:Expression tail:(__ "," __ Expression)* Elision? {
          return buildList(head, tail, 3);
        }

  /* ~~~~~~~~~~~~~~~ 3.15 - Conditional (Ternary) expression ~~~~~~~~~~~~~~~ */

    TernaryExpression
      = condition:ConditionalExpression __ "?" __ consequent:Expression __ ":" __ alternate:Expression {
          return { type: "TernaryExpression", condition, consequent, alternate, location: location() };
        }

  /* ~~~~~~~~~~~~~~~ 3.16 - Attribute & Decorator expressions ~~~~~~~~~~~~~~~ */

    RuntimeExpression
      = callee:IdentifierPath __ args:CallArguments {
          return { type: "CallExpression", callee, arguments: args, location: location() };
        }
      / IdentifierPath

    AttributeExpression
      = "[" __ head:RuntimeExpression tail:(__ "," __ RuntimeExpression) Elision? __ "]"  {
          return { type: "AttributeExpression", attributes: buildList(head, tail, 3), location: location() };
        }

    DecoratorExpression
      = "@" __ decorator:RuntimeExpression {
          return { type: "DecoratorExpression", decorators: [decorator], location: location() };
        }
      / "@" __ "(" __ head:RuntimeExpression (__ "," __ tail:RuntimeExpression) Elision? __ ")" {
          return { type: "DecoratorExpression", decorators: buildList(head, tail, 3), location: location() };
        }

  /* ~~~~~~~~~~~~~~~ 3.17 - Arrow expressions ~~~~~~~~~~~~~~~ */

    ArrowExpression
      = args:FunctionSignature operator:ArrowOperator __ statement:Block {
          return {
            type: "ArrowExpression",
            operator: operator,
            arguments: args.arguments,
            returns: args.returns,
            body: statement,
            location: location()
          };
        }
      / args:ArrowArguments? operator:ArrowOperator __ statement:Statement {
          return {
            type: "ArrowExpression",
            operator: operator,
            arguments: args || [],
            body: statement,
            location: location()
          };
        }

    ArrowOperator
      = "=>"
      / "->"

    ArrowArguments
      = arg:FormalParameter { return [arg]; }
      / FormalParameterList

  /* ~~~~~~~~~~~~~~~ 3.18 - Lambda expressions ~~~~~~~~~~~~~~~ */

    LambdaExpression
      = FunctionToken __ args:FunctionSignature __ block:Block {
          return {
            type: "LambdaExpression",
            arguments: args.arguments,
            returns: args.returns,
            body: block,
            location: location()
          };
        }

/* ############### 4 - Control Statements ############### */
  
  /* ~~~~~~~~~~~~~~~ 4.1 - Base statements ~~~~~~~~~~~~~~~ */

    Statement
      = BlockStatement
      / UsingStatement
      / ExpressionStatement

    StatementList
      = head:Statement tail:(__ Statement)* {
          return buildList(head, tail, 1);
        }
  
  /* ~~~~~~~~~~~~~~~ 4.2 - Block statements ~~~~~~~~~~~~~~~ */

    BlockStatement
      = body:Block EOS {
          return { type: "BlockStatement", body, location: location() };
        }

    Block
      = "{" __ body:(StatementList __)? "}" { return body ? body[0] : []; }
  
  /* ~~~~~~~~~~~~~~~ 4.3 - Using statements ~~~~~~~~~~~~~~~ */

    UsingStatement
      = UsingToken __ path:IdentifierPath EOS {
          return { type: "UsingStatement", path, location: location() };
        }
      / UsingToken __ identifier:Identifier __ "=" __ path:TypeExpression EOS {
          return { type: "TypeDefinition", identifier, path, location: location() };
        }
      / UsingToken __ path:Reference __ AsToken __ identifier:Identifier EOS {
          return { type: "TypeDefinition", identifier, path, location: location() };
        }

    UsingInheritanceStatement
      = UsingToken __ path:Reference EOS {
          return { type: "UsingStatement", path, location: location() };
        }
  
  /* ~~~~~~~~~~~~~~~ 4.6 - Variable statements ~~~~~~~~~~~~~~~ */

    TypedArray
      = kind:Identifier _ "[" _ size:(UnsignedInt _)? "]" {
          if ( size ) size = size[0];
          return { type: "TypedArray", kind, size, location: location() };
        }
  
  /* ~~~~~~~~~~~~~~~ 4.8 - Expression statements ~~~~~~~~~~~~~~~ */

    ExpressionStatement
      = !NonExpressionToken expression:SequenceExpression EOS { return expression; }
      / expression:NewExpression EOS { return expression; }

    NonExpressionToken
      = "{"
      / FunctionToken

/* ############### 5 - Functions ############### */
  
  /* ~~~~~~~~~~~~~~~ 5.1 - Function ~~~~~~~~~~~~~~~ */

    FunctionDefinition
      = modifier:(MethodModifier __)? header:FunctionHeader __ block:Block EOS {
          return {
            type: "FunctionDefinition",
            modifier: modifier,
            identifier: header.identifier,
            generics: header.generics,
            parameters: header.parameters,
            returns: header.returns,
            body: block,
            location: location()
          };
        }

    FunctionHeader
      = FunctionToken __ identifier:Identifier __ generics:(GenericParameterList __)? header:FunctionSignature {
          header.identifier = identifier;
          header.generics = generics ? generics[0] : [];
          return header;
        }

  /* ~~~~~~~~~~~~~~~ 5.2 - Function Arguments (Parameters) ~~~~~~~~~~~~~~~ */

    FunctionSignature
      = parameters:FormalParameterList returns:TypeArgument {
          return { parameters, returns };
        }

    FormalParameterList "arguments"
      = "(" __ ")" { return []; }
      / "(" __ argument:FormalParameter Elision? __ ")" { return [argument]; }
      / "(" __ head:NormalFormalParameter tail:FormalParameterTail Elision? __ ")" {
          return tail.length ? [head].concat(tail) : [head];
        }

    FormalParameterTail
      = head:(__ "," __ NormalFormalParameter)* tail:(__ "," __ DefaultFormalParameter)* {
          return buildList(extractList(head, 3), tail, 3);
        }

    FormalParameter
      = NormalFormalParameter
      / DefaultFormalParameter

    NormalFormalParameter "argument"
      = constant:(ConstToken __)? identifier:Identifier returns:TypeArgument !(__ "=" __ Expression) {
          return {
            type: "FormalParameter",
            constant: constant != null,
            identifier: identifier,
            returns: returns,
            location: location()
          };
        }

    DefaultFormalParameter "argument"
      = constant:(ConstToken __)? identifier:Identifier returns:TypeArgument __ "=" __ value:Expression {
          return {
            type: "FormalParameter",
            constant: constant != null,
            identifier: identifier,
            returns: returns,
            value: value,
            location: location()
          };
        }

/* ############### 9 - Program ############### */
  
  /* ~~~~~~~~~~~~~~~ 9.1 - Statement's ~~~~~~~~~~~~~~~ */

    /*DefinitionStatement
      = InterfaceDefinition
      / EnumDefinition
      / FunctionDefinition
      / StructDefinition
      / ClassDefinition
      / AbstractDefinition
      / DeclareDefinition*/
  
  /* ~~~~~~~~~~~~~~~ 9.2 - Import statements ~~~~~~~~~~~~~~~ */

    ImportStatement
      = ImportToken __ members:ImportMember __ FromToken __ source:StringLiteral EOS {
          return { type: "ImportStatement", source, members, location: location() };
        }
      / ImportToken __ source:StringLiteral EOS {
          return { type: "ImportStatement", source, location: location() };
        }

    ImportMember
      = ImportRest
      / member:ImportVariable rest:( __ "," __ (ImportRest / ImportAs))? {
          return rest ? [member, rest] : [member];
        }
      / "{" __ head:ImportVariable tail:(__ "," __ ImportVariable)* Elision? __ "}" {
          return buildList(head, tail, 3);
        }

    ImportRest
      = "*" _ AsToken _ name:Identifier {
          return [{
            type:     "AsExpression",
            object:   "*",
            alias:    name,
            location: location()
          }];
        }

    ImportVariable
      = Identifier
      / ImportAs

    ImportAs
      = object:Identifier _ AsToken _ alias:Identifier {
          return { type: "AsExpression", object, alias, location: location() };
        }
  
  /* ~~~~~~~~~~~~~~~ 9.3 - Program ~~~~~~~~~~~~~~~ */

    Program
      = __ elements:(ProgramStatement __)* EOF {
          return {
            type:         "Program",
            elements:     extractList(elements, 0),
            location:     location()
          };
        }

    ProgramStatement
      = ImportStatement
      // DefinitionStatement
      / Statement
