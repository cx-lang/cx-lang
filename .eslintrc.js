'use strict'

module.exports = {

  'extends': 'mdcs',
  'parser': 'babel-eslint',

  'rules': {

    // Possible Errors

    'no-cond-assign': [ 2, 'always' ],
    'no-debugger': 'error',
    'no-dupe-args': 'error',
    'no-dupe-keys': 'error',
    'no-duplicate-case': 'error',
    'no-extra-boolean-cast': 'error',
    'no-func-assign': 'error',
    'no-invalid-regexp': 'error',
    'no-prototype-builtins': 'error',
    'no-sparse-arrays': 'error',
    'no-unreachable': 'error',
    'no-unsafe-finally': 'error',
    'no-unsafe-negation': 'error',
    'use-isnan': 'error',
    'valid-typeof': 'error',

    // Best Practices

    'eqeqeq': 'error',
    'no-alert': 'error',
    'no-caller': 'error',
    'no-else-return': 'error',
    'no-fallthrough': 'error',
    'no-floating-decimal': 'error',
    'no-redeclare': 'error',
    'no-with': 'error',

    // Stylistic Issues

    'indent': [ 'error', 2, { 'SwitchCase': 2 } ],
    'no-mixed-spaces-and-tabs': 'error',
    'operator-assignment': [ 'error', 'always' ],
    'semi': [ 'error', 'never' ],
    'space-unary-ops': [ 'error', {

      'words': true,
      'nonwords': false,
      'overrides': {
        '!': true,
        '!!': true
      }

    } ],

    // ES6+

    'no-class-assign': 'error',
    'no-const-assign': 'error',
    'no-dupe-class-members': 'error',
    'no-duplicate-imports': [ 'error', { 'includeExports': true } ],
    'no-new-symbol': 'error',
    'no-this-before-super': 'error',
    'no-useless-computed-key': 'error',
    'no-useless-constructor': 'error',
    'no-useless-rename': 'error',
    'no-var': 'error',
    'prefer-const': 'error',
    'prefer-numeric-literals': 'error',
    'prefer-rest-params': 'error',
    'prefer-spread': 0,
    'symbol-description': 'error',
    'template-curly-spacing': [ 'error', 'always' ]

  }

}
