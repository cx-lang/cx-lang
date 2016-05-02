/*
  
  Originally based on the JavaScript pegjs example provided with PEG.js,
  this grammar file is built on work from a variety of pegjs grammar
  file's, mostly created by Futago-za Ryuu. Some grammar is also inspired
  by the ECMA-262 (6th edition) grammar examples.

  This grammar file has been split into many sections, and each section's
  content has been indented so that editors like Sublime Text can use
  code folding to make it easier for developers to work on this file.

  -----------------------------------------------------------------------

  TODO:

    1) Update sections 4+ to implement following:
          - Attributes (3.16)
          - Decorator's (3.16)
    2) Add support for multi-line RegExps (section 2.7 - Regular Expressions)
    3) https://en.wikipedia.org/wiki/List_comprehension
    4) https://babeljs.io/docs/learn-es2015/#symbols
    5) Implement C++/C# like pointer's and reference's

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
    const SYNTAX_REVISION = 0;

    function extractList ( list, index ) {
      var result = [], i, length = list.length;
      if ( length > 0 ) {
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
      if ( length > 0 ) {
        for ( i = 0; i < length; ++i ) {
          result = builder(result, tail[i]);
        }
      }
      return result;
    }
  
    const pegjs$location = location;
    location = function ( ) {
      var result = pegjs$location();
      if ( options.filename ) {
        result.filename = options.filename;
      }
      return result;
    };

    function constructConditionalStatement ( expression, alternate ) {
      return {
        type: "ConditionalStatement",
        condition: expression.condition,
        consequent: expression.consequent,
        alternate: alternate,
        location: location()
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
      = BlockCommentStart BlockCommentCharacter* "*/"

    MultiLineCommentNoLineTerminator
      = BlockCommentStart (!("*/" / LineTerminator) SourceCharacter)* "*/"

    SingleLineComment
      = "//" (!LineTerminator SourceCharacter)*

    DocumentBlock
      = "/**" value:$BlockCommentCharacter* "*/" {
          return { type: "DocumentBlock", value, location: location() };
        }

    BlockCommentStart
      = !"/**" "/*"

    BlockCommentCharacter
      = !"*/" SourceCharacter { return text(); }

  /* ~~~~~~~~~~~~~~~ 1.4 - Skipped ~~~~~~~~~~~~~~~ */

    __
      = (WhiteSpace / LineTerminatorSequence / Comment)*

    _
      = (WhiteSpace / MultiLineCommentNoLineTerminator)*

    EOS
      = __ ";"
      / _ SingleLineComment? LineTerminatorSequence
      // _ &"}"
      / __ EOF?

    EOF
      = !.

  /* ~~~~~~~~~~~~~~~ 1.5 - Tokens ~~~~~~~~~~~~~~~ */

    ArrayToken     = "array"
    AsToken        = "as"
    AsyncToken     = "async"
    AwaitToken     = "await"
    AutoToken      = "auto"
    BinaryToken    = "binary"
    BooleanToken   = "bool" / "boolean"
    BreakToken     = "break"
    CharToken      = "char"
    ConstToken     = "const"
    ContinueToken  = "continue"
    DeleteToken    = "delete"
    DoToken        = "do"
    ElseToken      = "else"
    EnumToken      = "enum"
    FalseToken     = "false"
    FloatToken     = "float"
    ForToken       = "for"
    FunctionToken  = "function"
    GetToken       = "get"
    GlobalToken    = "global"
    HexToken       = "hex"
    IfToken        = "if"
    ImportToken    = "import"
    InToken        = "in"
    InlineToken    = "inline"
    IntegerToken   = "int" / "integer"
    InternalToken  = "internal"
    LetToken       = "let"
    MacroToken     = "macro"
    NamespaceToken = "namespace"
    NewToken       = "new"
    NullToken      = "null"
    ObjectToken    = "object"
    OctalToken     = "octal"
    OfToken        = "of"
    PrivateToken   = "private"
    ProtectedToken = "protected"
    PublicToken    = "public"
    RegExpToken    = "regexp"
    ReturnToken    = "return"
    SetToken       = "set"
    StaticToken    = "static"
    StringToken    = "string"
    StructToken    = "struct"
    SuperToken     = "super"
    TemplateToken  = "template"
    ThisToken      = "this"
    TrueToken      = "true"
    TypeofToken    = "typeof"
    UsingToken     = "using"
    VarToken       = "var"
    VoidToken      = "void"
    WhileToken     = "while"

  /* ~~~~~~~~~~~~~~~ 1.6 - Keywords ~~~~~~~~~~~~~~~ */

    ContextKeyword
      = GlobalToken
      / InternalToken
      / SuperToken
      / ThisToken

    AssignmentKeyword
      = VarToken
      / LetToken

    ReturnKeyword
      = AutoToken
      / VoidToken

    PrimitiveKeyword
      = BooleanToken
      / IntegerToken
      / FloatToken
      / BinaryToken
      / OctalToken
      / HexToken
      / CharToken
      / StringToken
      / RegExpToken
      / TemplateToken
      / ObjectToken
      / ArrayToken

    MethodModifierKeyword
      = InlineToken
      / MacroToken
      / AsyncToken

    AccessModifierKeyword
      = PrivateToken
      / ProtectedToken
      / PublicToken
      / StaticToken

    Keyword
      = ContextKeyword
      / AssignmentKeyword
      / ReturnKeyword
      / MethodModifierKeyword
      / AccessModifierKeyword
      / ConstToken
      / FalseToken
      / NullToken
      / TrueToken
      / NewToken
      / DeleteToken
      / AsToken
      / InToken
      / OfToken

      / UsingToken
      / ImportToken
      / AwaitToken
      / IfToken
      / ElseToken
      / DoToken
      / WhileToken
      / ForToken
      / ContinueToken
      / BreakToken
      / ReturnToken

      / FunctionToken
      / EnumToken
      / StructToken
      / NamespaceToken

  /* ~~~~~~~~~~~~~~~ 1.7 - Identifiers ~~~~~~~~~~~~~~~ */

    Identifier
      = !Keyword name:IdentifierName { return name; }

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

    IdentifierPath
      = head:Identifier tail:(__ "." __ IdentifierName)+ {
          return { type: "IdentifierPath", value: buildList(head, tail, 3), location: location() };
        }
      / Identifier

  /* ~~~~~~~~~~~~~~~ 1.8 - Modifiers ~~~~~~~~~~~~~~~ */

    MethodModifiers
      = head:MethodModifier tail:(__ MethodModifier)* { return buildList(head, tail, 1); }

    MethodModifier
      = MethodModifierKeyword
      // AccessModifier

    AccessModifiers
      = head:AccessModifier tail:(__ AccessModifier)* { return buildList(head, tail, 1); }

    AccessModifier
      = InternalToken
      / AccessModifierKeyword

    NamespaceModifier
      = PrivateToken
      / InternalToken

    AssignmentModifier
      = ConstToken value:AssignmentLiteral? {
          return { type: "ConstantModifier", value, location: location() };
        }
      / AssignmentLiteral

/* ############### 2 - Literals ############### */

  /* ~~~~~~~~~~~~~~~ 2.1 - Literal Rule ~~~~~~~~~~~~~~~ */

    Literal
      = NullLiteral
      / BooleanLiteral
      / ContextLiteral
      / NumericLiteral
      / CharLiteral
      / StringLiteral
      / RegExpLiteral
      / TemplateLiteral

  /* ~~~~~~~~~~~~~~~ 2.2 - Token based literals ~~~~~~~~~~~~~~~ */

    NullLiteral
      = NullToken { return { type: "NullLiteral", location: location() }; }

    BooleanLiteral
      = value:(TrueToken / FalseToken) {
          return { type: "BooleanLiteral", value, location: location() };
        }

    ContextLiteral
      = value:ContextKeyword { return { type: "ContextLiteral", value, location: location() }; }

    AssignmentLiteral
      = value:AssignmentKeyword { return { type: "AssignmentLiteral", value, location: location() }; }

    ReturnLiteral
      = value:ReturnKeyword { return { type: "ReturnLiteral", value, location: location() }; }

    PrimitiveLiteral
      = value:PrimitiveKeyword  { return { type: "PrimitiveLiteral", value, location: location() }; }

  /* ~~~~~~~~~~~~~~~ 2.3 - Numbers ~~~~~~~~~~~~~~~ */

    NumericLiteral
      = DecimalLiteral
      / BinaryLiteral
      / OctalLiteral
      / HexLiteral

    Integer "int"
      = $DecimalDigit+

    Float "float"
      = f:$(Integer "." Integer) "f"? { return f; }
      / f:("." Integer) "f"? { return f; }
      / f:Integer "f" { return f; }

    Exponent "exponent"
      = "e"i sign:[+-]? value:Integer {
          return { value, sign };
        }

    UnsignedInt "unsigned int"
      = value:Integer {
          return { type: 'IntegerLiteral', value, location: location() };
        }

    SignedInt "signed int"
      = sign:[+-] value:Integer {
          return { type: 'IntegerLiteral', sign, value, location: location() };
        }

    DecimalLiteral
      = sign:[+-]? value:Integer exponent:Exponent? {
          return { type: 'IntegerLiteral', sign, value, exponent, location: location() };
        }
      / sign:[+-]? value:Float exponent:Exponent? {
          return { type: 'FloatLiteral', sign, value, exponent, location: location() };
        }

    BinaryLiteral "binary"
      = "0b"i digits:$BinaryDigit+ {
          return { type: "BinaryLiteral", value: "0b" + digits, location: location() };
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

  /* ~~~~~~~~~~~~~~~ 2.6 - Template strings ~~~~~~~~~~~~~~~ */

    TemplateLiteral "template"
      = tag:TemplateTag? "`" string:TemplateString "`" {
          return { type: "TemplateLiteral", tag, parts: [string], location: location() };
        }
      / tag:TemplateTag? head:SubstitutionHead centre:SubstitutionMiddle* tail:SubstitutionTail {
          var parts = [head], i = 0;
          if ( centre && centre.length ) {
            centre.forEach(function(middle){
              parts[++i] = middle[0];
              parts[++i] = middle[1];
              parts[++i] = middle[2];
            });
          }
          parts[++i] = tail[0];
          parts[++i] = tail[1];
          return { type: "TemplateLiteral", tag, parts, location: location() };
        }

    TemplateTag
      = tag:TypeName _ { return tag; }

    SubstitutionHead
      = "`" string:TemplateString "${" { return string; }

    SubstitutionMiddle
      = left:TemplateExpression "}" string:TemplateString "${" right:TemplateExpression { return [left, string, right]; }

    SubstitutionTail
      = left:TemplateExpression "}" string:TemplateString "`" { return [left, string]; }

    TemplateExpression
      = RelationalExpression
      / UpdateExpression
      / UnaryExpression
      / BaseLeftHandSideExpression
      / TernaryExpression

    TemplateString
      = chars:$TemplateStringCharacter* {
          return { string: JSON.stringify(chars), location: location() };
        }

    TemplateStringCharacter
      = !("${" / "`" / "\\" / LineTerminator)  SourceCharacter { return text(); }
      / "\\" sequence:TemplateEscapeSequence { return sequence; }
      / LineContinuation
      / LineTerminatorSequence

    TemplateEscapeSequence
      = "${"
      / "`"
      / EscapeSequence

  /* ~~~~~~~~~~~~~~~ 2.7 - Regular Expressions ~~~~~~~~~~~~~~~ */

    RegExpLiteral "regular expression"
      = "/" chars:$RegExpCharacter+ "/" flags:($AlphaCharacter+)? {
          return { type: "RegExpLiteral", value: JSON.stringify(chars), flags, location: location() };
        }

    RegExpCharacter
      = '\\' "/" { return "/"; }
      / !("/" / LineTerminator) SourceCharacter { return text(); }

/* ############### 3 - Expressions ############### */

  /* ~~~~~~~~~~~~~~~ 3.1 - Base expressions ~~~~~~~~~~~~~~~ */

    SequenceExpression
      = head:Expression tail:(__ "," __ Expression)+ {
          return { type: "SequenceExpression", expressions: buildList(head, tail, 3), location: location() };
        }
      / Expression

    PrimaryExpression
      = TypeName
      / Literal
      / ArrayExpression
      / WrappedExpression

    WrappedExpression
      = "(" __ expression:Expression __ ")" { return expression; }

    BaseLeftHandSideExpression
      = path:IdentifierPath !MemberProperty { return path; } 
      / CallExpression
      / MemberExpression

    LeftHandSideExpression
      = BaseLeftHandSideExpression
      / WrappedNewExpression

    BaseExpression
      = TypeCastExpression
      / LambdaExpression
      / AssignmentExpression
      / RelationalExpression
      / UpdateExpression
      / UnaryExpression
      / LeftHandSideExpression

    Expression
      = BaseExpression
      / TernaryExpression

    ConditionalExpression
      = BaseExpression
      / WrappedExpression

  /* ~~~~~~~~~~~~~~~ 3.2 - Type expressions ~~~~~~~~~~~~~~~ */

    TypeName
      = PrimitiveLiteral
      / IdentifierPath
      / GenericName

    TypedArray
      = kind:TypeName _ "[" _ size:(UnsignedInt _)? "]" {
         return { type: "TypedArray", kind, size, location: location() };
        }

    TypeIdentifier
      = TypedArray
      / TypeName

    UnionExpression
      = head:TypeIdentifier tail:(__ "|" __ TypeIdentifier)+ {
          return { type: "UnionExpression", value: buildList(head, tail, 3), location: location() };
        }

    TypeExpression
      = UnionExpression
      / TypeIdentifier

    WrappedTypeExpression
      = "(" _ expression:TypeExpression _ ")" { return expression; }

    ReturnType
      = WrappedTypeExpression
      / TypeExpression

    TypeArgument
      = __ ":" __ expression:ReturnType { return expression; }

    ReturnArgument
      = __ ":" __ expression:(ReturnLiteral / ReturnType) { return expression; }

    TypeCastExpression
      = "(" __ returns:TypeIdentifier __ ")" __ expression:Expression {
          return { type: "CastExpression", returns, expression, location: location() };
        }

  /* ~~~~~~~~~~~~~~~ 3.3 - Generic expressions ~~~~~~~~~~~~~~~ */

    GenericName
      = value:IdentifierPath __ args:GenericInitializer {
          return { type: 'GenericName', value, arguments: args, location: location() };
        }

    GenericInitializer
      = "<" __ ">" { return []; }
      / "<" __ head:TypeIdentifier tail:(__ "," __ TypeIdentifier)* (__ ",")? __ ">" {
          return buildList(head, tail, 3);
        }

    GenericConstructor
      = "<" __ head:GenericArgument tail:(__ "," __ GenericArgument)* (__ ",")? __ ">" {
          return buildList(head, tail, 3);
        }

    GenericArgument
      = identifier:Identifier value:(__ "=" __ TypeIdentifier)? {
          return {
            type: "GenericArgument",
            identifier: identifier,
            value: value ? value[3] : null,
            location: location()
          };
        }

  /* ~~~~~~~~~~~~~~~ 3.4 - Spread and Rest expressions ~~~~~~~~~~~~~~~ */

    SpreadExpression
      = IntegerSpread
      / RestExpression

    IntegerSpread
      = "..." value:UnsignedInt {
          return { type: "IntegerSpread", value, location: location() };
        }

    RestExpression
      = "..." value:IdentifierPath {
          return { type: "RestExpression", value, location: location() };
        }

  /* ~~~~~~~~~~~~~~~ 3.5 - Ranges ~~~~~~~~~~~~~~~ */

    RangeExpression
      = from:RangeInt? operator:RangeOperator to:RangeInt? {
          return { type: "RangeExpression", from, operator, to, location: location() };
        }

    RangeInt
      = SignedInt
      / UnsignedInt

    RangeOperator
      = ".."
      / "..."

  /* ~~~~~~~~~~~~~~~ 3.6 - Array containers ~~~~~~~~~~~~~~~ */

    ArrayExpression "array"
      = "[" __ elements:ArrayElementList? __ "]" {
          return { type: "ArrayExpression", elements: elements || [], location: location() };
        }

    ArrayElementList
      = head:ArrayElement tail:(__ "," __ element:ArrayElement)* __ ","? {
          return buildList(head, tail, 3);
        }

    ArrayElement
      = key:UnsignedInt __ ":" __ value:Expression {
          return { type: "ElementAssignment", key, value, location: location() };
        }
      / SpreadExpression
      / Expression

  /* ~~~~~~~~~~~~~~~ 3.7 - Object containers ~~~~~~~~~~~~~~~ */

    ObjectExpression "object"
      = "{" __ properties:ObjectPropertyList __ "}" {
          return { type: "ObjectExpression", properties, location: location() };
        }

    ObjectPropertyList
      = head:ObjectProperty tail:(__ "," __ element:ObjectProperty)* __ ","? {
          return buildList(head, tail, 3);
        }

    ObjectProperty
      = key:PropertyName __ ":" __ value:VariableValue {
          return { type: "PropertyAssignment", key, value, location: location() };
        }
      / RestExpression
      / IdentifierPath

    PropertyName
      = IdentifierName
      / CharLiteral
      / StringLiteral
      / NumericLiteral

  /* ~~~~~~~~~~~~~~~ 3.8 - New expressions ~~~~~~~~~~~~~~~ */

    NewExpression
      = NewToken __ callee:TypeName __ args:CallArguments {
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
      = IdentifierPath
      / WrappedNewExpression
      / PrimaryExpression

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
          return buildTree(head, tail, function(result, element){
            element[element.type === "CallExpression" ? "callee" : "object"] = result;
            return element;
          });
        }

    CallArguments
      = generic_args:GenericInitializer? __ "(" __ method_args:(CallArgumentList __)? ")" {
          return  { generic: generic_args || [], call: method_args ? method_args[0] : [] };
        }

    CallArgumentList
      = head:Expression tail:(__ "," __ Expression)* {
          return buildList(head, tail, 3);
        }

  /* ~~~~~~~~~~~~~~~ 3.11 - Assignment expressions ~~~~~~~~~~~~~~~ */

    AssignmentExpression
      = left:LeftHandSideExpression __ operator:AssignmentOperator __ right:Expression {
          return { type: "AssignmentExpression", left, operator, right, location: location() };
        }

    AssignmentOperator
      = "=" (!"=") { return "="; }
      / ".="
      / "?="
      / "*="
      / "**="
      / "/="
      / "%="
      / "+="
      / "-="
      / "<<="
      / ">>="
      / ">>>="
      / "&="
      / "^="
      / "|="

  /* ~~~~~~~~~~~~~~~ 3.12 - Relational expressions ~~~~~~~~~~~~~~~ */

    RelationalExpression
      = left:UnaryExpression __ operator:RelationalOperator __ right:UnaryExpression {
          return { type: "RelationalExpression", left, operator, right, location: location() };
        }

    RelationalOperator
      = MultiplicativeOperator
      / AdditiveOperator
      / ShiftOperator
      / ComparativeOperator
      / EqualityOperator
      / BitwiseOperator
      / LogicalOperator

    MultiplicativeOperator
      = $("*" !"=")
      / $("**" !"=")
      / $("/" !"=")
      / $("%" !"=")

    AdditiveOperator
      = $("+" ![+=])
      / $("-" ![-=])

    ShiftOperator
      = $("<<"  !"=")
      / $(">>>" !"=")
      / $(">>"  !"=")
      / $AsToken

    ComparativeOperator
      = "<="
      / ">="
      / $("<" !"<")
      / $(">" !">")
      / $InToken
      / $OfToken
      / "??"

    EqualityOperator
      = "=="
      / "!="

    BitwiseOperator
      = $("&" ![&=]) // AND
      / $("^" !"=")  // XOR
      / $("|" ![|=]) // OR

    LogicalOperator
      = "&&" // AND
      / "||" // OR

  /* ~~~~~~~~~~~~~~~ 3.13 - Update expressions ~~~~~~~~~~~~~~~ */

    UpdateExpression
      = argument:LeftHandSideExpression __ operator:UpdateOperator {
          return { type: "UpdateExpression", operator, argument, prefix: false, location: location() };
        }
      / LeftHandSideExpression

    UpdateOperator
      = "++"
      / "--"
      / $("**" !"=")
      / $("^" !"=")

  /* ~~~~~~~~~~~~~~~ 3.14 - Unary expressions ~~~~~~~~~~~~~~~ */

    UnaryExpression
      = UpdateExpression
      / operator:UpdateOperator __ argument:UnaryExpression {
          return { type: "UpdateExpression", operator, argument, prefix: true, location: location() };
        }
      / operator:UnaryOperator __ argument:UnaryExpression {
          return { type: "UnaryExpression", operator, argument, location: location() };
        }

    UnaryOperator
      = $DeleteToken
      / $TypeofToken
      / $("+" !"=")
      / $("-" !"=")
      / "~"
      / $("!" !"=")

  /* ~~~~~~~~~~~~~~~ 3.15 - Conditional (Ternary) expression ~~~~~~~~~~~~~~~ */

    TernaryExpression
      = condition:ConditionalExpression __ "?" __ consequent:Expression __ ":" __ alternate:Expression {
          return { type: "TernaryExpression", condition, consequent, alternate, location: location() };
        }

  /* ~~~~~~~~~~~~~~~ 3.16 - Attribute & Decorator expressions ~~~~~~~~~~~~~~~ */

    RuntimeExpression
      = CallExpression
      / IdentifierPath

    AttributeExpression
      = "[" __ head:RuntimeExpression tail:(__ "," __ RuntimeExpression) (__ ",")? __ "]"  {
          return { type: "AttributeExpression", attributes: buildList(head, tail, 3), location: location() };
        }

    DecoratorExpression
      = "@" __ decorator:RuntimeExpression {
          return { type: "DecoratorExpression", decorators: [decorator], location: location() };
        }
      / "@" __ "(" __ head:RuntimeExpression (__ "," __ tail:RuntimeExpression) (__ ",")? __ ")" {
          return { type: "DecoratorExpression", decorators: buildList(head, tail, 3), location: location() };
        }

  /* ~~~~~~~~~~~~~~~ 3.17 - Arrow expressions ~~~~~~~~~~~~~~~ */

    ArrowExpression
      = args:FunctionArguments operator:ArrowOperator __ statement:BlockBody {
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
      = arg:FunctionArgument { return [arg]; }
      / FunctionArgumentList

  /* ~~~~~~~~~~~~~~~ 3.18 - Lambda expressions ~~~~~~~~~~~~~~~ */

    LambdaExpression
      = FunctionToken __ args:FunctionArguments __ block:BlockBody {
          return {
            type: "LambdaExpression",
            arguments: args.arguments,
            returns: args.returns,
            body: block,
            location: location()
          };
        }
      / ArrowExpression

/* ############### 4 - Control Statements ############### */
  
  /* ~~~~~~~~~~~~~~~ 4.1 - Base statements ~~~~~~~~~~~~~~~ */

    Statement
      = BlockStatement
      / UsingStatement
      / AwaitStatement
      / VariableStatement
      / ConditionalStatement
      / DoStatement
      / WhileStatement
      / ForStatement
      / ContinueStatement
      / BreakStatement
      / ReturnStatement
      // SwitchStatement
      // ThrowStatement
      // TryStatement
      // YieldStatement
      // FunctionDefinition
      / ExpressionStatement

    StatementList
      = head:Statement tail:(__ Statement)* { return buildList(head, tail, 1); }
  
  /* ~~~~~~~~~~~~~~~ 4.2 - Block statements ~~~~~~~~~~~~~~~ */

    BlockStatement
      = body:BlockBody EOS {
          return { type: "BlockStatement", body, location: location() };
        }

    BlockBody
      = "{" __ body:(StatementList __)? "}" { return body ? body[0] : []; }
  
  /* ~~~~~~~~~~~~~~~ 4.3 - Import and Using statements ~~~~~~~~~~~~~~~ */

    UsingStatement
      = UsingToken __ path:IdentifierPath EOS {
          return { type: "UsingStatement", path, location: location() };
        }
      / UsingToken __ identifier:Identifier __ "=" __ path:ReturnType EOS {
          return { type: "TypeDefinition", identifier, path, location: location() };
        }
      / UsingToken __ path:ReturnType __ AsToken __ identifier:Identifier EOS {
          return { type: "TypeDefinition", identifier, path, location: location() };
        }

    UsingInheritanceStatement
      = UsingToken __ path:TypeIdentifier EOS {
          return { type: "UsingStatement", path, location: location() };
        }

    ImportStatement
      = ImportToken __ path:IdentifierPath EOS {
          return { type: "ImportStatement", path, location: location() };
        }
      / ImportToken __ path:IdentifierPath __ AsToken __ identifier:Identifier EOS {
          return { type: "ImportStatement", path, identifier, location: location() };
        }
      / modifier:AssignmentModifier __ identifier:Identifier __ "=" __ ImportToken __ path:IdentifierPath EOS {
          return { type: "ImportStatement", modifier, path, identifier, location: location() };
        }
      / destructor:DestructorExpression __ "=" __ ImportToken __ path:IdentifierPath EOS {
          return { type: "ImportStatement", path, destructor, location: location() };
        }

  /* ~~~~~~~~~~~~~~~ 4.4 - Await statements ~~~~~~~~~~~~~~~ */

    AwaitStatement
      = expression:(AwaitAssignment / AwaitExpression) EOS { return expression; }

    AwaitAssignment
      = identifier:Identifier kind:TypeArgument __ "=" __ value:AwaitExpression {
          return {
            type: "AwaitAssignment",
            identifier: identifier,
            kind: kind,
            value: value,
            location: location()
          };
        }

    AwaitExpression
      = AwaitToken __ callback:CallExpression {
          return { type: 'AwaitExpression', callback, location: location() };
        }

  /* ~~~~~~~~~~~~~~~ 4.5 - Destructor expressions ~~~~~~~~~~~~~~~ */

    DestructorAssignment
      = destructor:DestructorExpression __ "=" __ value:DestructorElement {
          return {
            type: "DestructorAssignment",
            destructor: destructor,
            value: value,
            location: location()
          };
        }

    DestructorElement
      = AwaitExpression
      / TypeName
      / Expression

    DestructorExpression
      = "{" __ elements:DestructorList __ "}" returns:TypeArgument {
          return { type: "DestructorExpression", returns, elements, location: location() };
        }

    DestructorList
      = head:DestructorArgument tail:(__ "," __ DestructorArgument)* { return buildList(head, tail, 3); }

    DestructorArgument
      = identifier:Identifier {
          return {
            type: "DestructorArgument",
            identifier: identifier,
            location: location()
          };
        }
  
  /* ~~~~~~~~~~~~~~~ 4.6 - Variable statements ~~~~~~~~~~~~~~~ */

    DeclarationKind
      = AssignmentModifier
      / WrappedTypeExpression
      / TypeIdentifier

    VariableStatement
      = kind:(DeclarationKind __)? declarations:VariableList EOS {
          return {
            type: "VariableStatement",
            kind: kind ? kind[0] : null,
            declarations: declarations,
            location: location()
          };
        }

    VariableList
      = head:VariableItem tail:(__ "," __ VariableItem)* EOS {
          return buildList(head, tail, 3);
        }

    VariableItem
      = DestructorAssignment
      / AwaitAssignment
      / VariableModifier
      / VariableAssignment
      / VariableDeclaration

    VariableAssignment
      = identifier:Identifier kind:TypeArgument __ "=" __ value:VariableValue {
          return { type: "VariableAssignment", identifier, kind, value, location: location() };
        }

    VariableDeclaration
      = identifier:Identifier kind:TypeArgument {
          return { type: "VariableDeclaration", identifier, kind, location: location() };
        }

    VariableValue
      = ObjectExpression
      / NewExpression
      / Expression
  
  /* ~~~~~~~~~~~~~~~ 4.7 - Accessor & Mutator statements ~~~~~~~~~~~~~~~ */

    VariableModifier
      = identifier:Identifier kind:TypeArgument __ "=" __ "{" __ expression:ModifierExpression __ "}" {
          expression.type = "VariableModifier";
          expression.kind = kind;
          expression.identifier = identifier;
          expression.location = location();
        }

    ModifierExpression
      = accessor:AccessorExpression { return { accessor }; }
      / mutator:MutatorExpression { return { mutator }; }
      / accessor:AccessorExpression __ ("," __)? mutator:MutatorExpression {
          return { accessor, mutator };
        }
      / mutator:MutatorExpression __ ("," __)? accessor:AccessorExpression {
          return { accessor, mutator };
        }

    AccessorExpression
      = GetToken __ ("(" __ ")" __)? body:BlockBody {
          return { type: "AccessorExpression", body, location: location() };
        }

    MutatorExpression
      = SetToken __ param:("(" __ Identifier __ ")" __)? body:BlockBody {
          param = param ? param[2] : { type: "Identifier", value: "value", location: location() };
          return { type: "MutatorExpression", param, body, location: location() };
        }
  
  /* ~~~~~~~~~~~~~~~ 4.8 - Expression statements ~~~~~~~~~~~~~~~ */

    ExpressionStatement
      = !("{" / FunctionToken) expression:SequenceExpression EOS { return expression; }
      / NewExpression
  
  /* ~~~~~~~~~~~~~~~ 4.9 - if/else statements ~~~~~~~~~~~~~~~ */

    ConditionalStatement
      = expression:IfExpression alternate:ElseExpression? {
          return constructConditionalStatement(expression, alternate);
        }
      / condition:ConditionalExpression __ "?" __ consequent:Statement {
          return { type: "ConditionalStatement", condition, consequent, location: location() };
        }
      / TernaryExpression

    IfExpression
      = IfToken __ "(" __ condition:ConditionalExpression __ ")" __ consequent:Statement { return { condition, consequent }; }

    ElseExpression
      = __ ElseToken __ alternate:Statement { return alternate; }
  
  /* ~~~~~~~~~~~~~~~ 4.10 - do/while statements ~~~~~~~~~~~~~~~ */

    DoStatement
      = DoToken __ statement:Statement __ WhileToken __ "(" __ condition:Expression __ ")" EOS {
          return { type: "DoStatement", condition, statement, location: location() };
        }

    WhileStatement
      = WhileToken __ "(" __ condition:Expression __ ")" __ statement:Statement {
          return { type: "WhileStatement", condition, statement, location: location() };
        }
  
  /* ~~~~~~~~~~~~~~~ 4.11 - for(each) statements ~~~~~~~~~~~~~~~ */

    ForStatement
      = ForToken __ "(" __
          init:(VariableStatement __)? ";" __ test:(Expression __)? ";" __ update:(Expression __)?
        ")" __ body:Statement {
          return {
            type: "ForStatement",
            init: init ? init[0] : null,
            test: test ? test[0] : null,
            update: update ? update[0] : null,
            body: body,
            location: location()
          };
        }
      / ForToken __ "(" __ identifier:Identifier __ InToken __ object:Expression __ ")" __ body:Statement {
          return { type: "ForInStatement", identifier, object, body, location: location() };
        }
      / ForToken __ "(" __ object:Expression __ AsToken __ identifiers:ForKeyValue __ ")" __ body:Statement {
          return { type: "ForAsStatement", object, identifiers, body, location: location() };
        }
      / ForToken __ "(" __ identifiers:ForKeyValue __ OfToken __ object:Expression __ ")" __ body:Statement {
          return { type: "ForOfStatement", identifiers, object, body, location: location() };
        }

    ForKeyValue
      = key:VariableDeclaration __ "," __ value:VariableDeclaration {
          return { key: key, value: value };
        }
  
  /* ~~~~~~~~~~~~~~~ 4.12 - Control flow statements ~~~~~~~~~~~~~~~ */

    ContinueStatement
      = ContinueToken EOS { return { type: "ContinueStatement", location: location() }; }

    BreakStatement
      = BreakToken EOS { return { type: "BreakStatement", location: location() }; }

    ReturnStatement
      = ReturnToken argument:(_ Expression)? EOS {
          return {
            type: "ReturnStatement",
            argument: argument ? argument[1] : null,
            location: location()
          };
        }

/* ############### 5 - Functions ############### */
  
  /* ~~~~~~~~~~~~~~~ 5.1 - Function ~~~~~~~~~~~~~~~ */

    FunctionDefinition
      = modifier:(MethodModifier __)? header:FunctionHeader __ block:BlockBody EOS {
          return {
            type: "FunctionDefinition",
            modifier: modifier,
            identifier: header.identifier,
            generics: header.generics,
            arguments: header.arguments,
            returns: header.returns,
            body: block,
            location: location()
          };
        }

    FunctionHeader
      = FunctionToken __ identifier:Identifier __ generics:(GenericConstructor __)? header:FunctionArguments {
          header.identifier = identifier;
          header.generics = generics;
          return header;
        }

  /* ~~~~~~~~~~~~~~~ 5.2 - Function Arguments (Parameters) ~~~~~~~~~~~~~~~ */

    FunctionArguments "arguments"
      = args:FunctionArgumentList returns:ReturnArgument {
          return { arguments: args, returns };
        }

    FunctionArgumentList
      = "(" __ ")" { return []; }
      / "(" __ argument:FunctionArgument __ ")" { return argument; }
      / "(" __ head:FunctionNormalArgument tail:FunctionArgumentTail (__ ",")? __ ")" {
          return [head].concat(tail);
        }

    FunctionArgumentTail
      = head:(__ "," __ FunctionNormalArgument)* tail:(__ "," __ FunctionDefaultArgument)* {
          return extractList(head, 3).concat(extractList(tail, 3));
        }

    FunctionArgument
      = FunctionNormalArgument
      / FunctionDefaultArgument

    FunctionNormalArgument "argument"
      = constant:(ConstToken __)? identifier:Identifier returns:TypeArgument __ !("=" __ Expression) {
          return {
            type: "FunctionArgument",
            constant: constant != null,
            identifier: identifier,
            returns: returns,
            location: location()
          };
        }

    FunctionDefaultArgument "argument"
      = constant:(ConstToken __)? identifier:Identifier returns:TypeArgument __ "=" __ value:Expression {
          return {
            type: "FunctionArgument",
            constant: constant != null,
            identifier: identifier,
            returns: returns,
            value: value,
            location: location()
          };
        }

/* ############### 6 - Classes and Objects ############### */
  
  /* ~~~~~~~~~~~~~~~ 6.1 - Enum's ~~~~~~~~~~~~~~~ */

    EnumDefinition
      = EnumToken __ generic:(GenericInitializer __)? identifier:Identifier __ block:EnumBlock EOS {
          return {
            type: "EnumDefinition",
            arguments: generic ? generic[0] : null,
            identifier: identifier,
            properties: block,
            location: location()
          };
        }

    EnumBlock
      = "{" __ head:EnumArgument tail:(__ ","? __ EnumArgument)* __ "}" { return buildList(head, tail, 3); }

    EnumArgument
      = UsingInheritanceStatement
      / EnumPropertyAssignment
      / ConditionalEnumStatement

    EnumPropertyAssignment
      = identifier:Identifier value:(__ (":" / "=") __ NumericLiteral)? {
          return { type: "EnumProperty", identifier, value: value ? value[3] : null, location: location() };
        }

    ConditionalEnumStatement
      = expression:ifEnumExpression alternate:ElseEnumExpression? {
          return constructConditionalStatement(expression, alternate);
        }

    ifEnumExpression
      = IfToken __ "(" __ condition:ConditionalExpression __ ")" __ consequent:ConditionalEnumElement { return { condition, consequent }; }

    ElseEnumExpression
      = __ ElseToken __ alternate:ConditionalEnumElement { return alternate; }

    ConditionalEnumElement
      = "{" __ "}" { return []; }
      / "{" __ head:EnumArgument tail:(__ ","? __ EnumArgument)* __ "}" { return buildList(head, tail, 3); }
      / e:EnumArgument { return [e]; }
  
  /* ~~~~~~~~~~~~~~~ 6.2 - Struct's ~~~~~~~~~~~~~~~ */

    StructDefinition
      = struct:StructHead properties:StructBlock {
          struct.properties = properties;
          struct.location = location();
          return struct;
        }

    StructHead
      = StructToken __ id:Identifier generics:(__ GenericConstructor)? argument:(__ StructArgument)? {
          return {
            type: "StructDefinition",
            identifier: id,
            generics: generics ? generics[1] : [],
            argument: argument ? argument[1] : null
          };
        }

    StructArgument
      = "(" __ argument:TypeExpression __ ")" { return argument; }

    StructBlock
      = "{" __ "}" { return []; }
      / "{" __ head:StructElement tail:(__ StructElement)* __ "}" { return buildList(head, tail, 1); }

    StructElement
      = ConditionalStructStatement
      / UsingInheritanceStatement
      / VariableStatement
      / FunctionDefinition

    ConditionalStructStatement
      = expression:ifStructExpression alternate:ElseStructExpression? {
          return constructConditionalStatement(expression, alternate);
        }

    ifStructExpression
      = IfToken __ "(" __ condition:ConditionalExpression __ ")" __ consequent:StructBlock { return { condition, consequent }; }

    ElseStructExpression
      = __ ElseToken __ alternate:StructBlock { return alternate; }

/* ############### 7 - Declare and Extern ############### */
  
  /* ~~~~~~~~~~~~~~~ 7.1 - Headers ~~~~~~~~~~~~~~~ */

    

/* ############### 8 - Namespace's and Program ############### */
  
  /* ~~~~~~~~~~~~~~~ 8.1 - Elements and Statements ~~~~~~~~~~~~~~~ */

    NamespaceElement
      = UsingStatement
      / ImportStatement
      / NamespaceDefinition
      // DeclareDefinition
      // ExternDefinition
      / EnumDefinition
      / StructDefinition
      // ClassDefinition
      // InterfaceDefinition
      / FunctionDefinition
      / ConditionalNamespaceStatement

    NamespaceStatement
      = modifier:NamespaceModifier __ element:NamespaceElement {
          return { type: "NamespaceElement", modifier, element, location: location() };
        }
      / NamespaceElement

    ProgramStatement
      = NamespaceStatement
      / Statement
  
  /* ~~~~~~~~~~~~~~~ 8.2 - Namespace based if/else statements ~~~~~~~~~~~~~~~ */

    ConditionalNamespaceStatement
      = expression:ifNamespaceExpression alternate:ElseNamespaceExpression? {
          return constructConditionalStatement(expression, alternate);
        }

    ifNamespaceExpression
      = IfToken __ "(" __ condition:ConditionalExpression __ ")" __ consequent:ConditionalNamespaceElement { return { condition, consequent }; }

    ElseNamespaceExpression
      = __ ElseToken __ alternate:ConditionalNamespaceElement { return alternate; }

    ConditionalNamespaceElement
      = "{" __ "}" { return []; }
      / "{" __ head:NamespaceStatement tail:(__ NamespaceStatement)* __ "}" { return buildList(head, tail, 1); }
  
  /* ~~~~~~~~~~~~~~~ 8.4 - Namespace Definition ~~~~~~~~~~~~~~~ */

    NamespaceDefinition
      = NamespaceToken __ identifier:IdentifierPath __ "{" __ statements:NamespaceStatements __ "}" EOS {
          return { type: "NamespaceDefinition", identifier, statements, location: location() };
        }

    NamespaceStatements
      = elements:(NamespaceStatement __)* { return extractList(elements, 0); }
  
  /* ~~~~~~~~~~~~~~~ 8.5 - Program ~~~~~~~~~~~~~~~ */

    Program
      = __ elements:(ProgramStatement __)* EOF {
          return {
            type: "Program",
            revision: SYNTAX_REVISION,
            elements: extractList(elements, 0),
            location: location()
          };
        }
