BUILTIN_CONST_MACROS
    = "__LINE__"i {

        return {

            type: 'IntegarLiteral',
            value: peg$computePosDetails( peg$savedPos ).line,
            location: location()

        };

    }
    / "__MTIME__"i {

        return {

            type: 'IntegarLiteral',
            value: $tracker.mtime(),
            location: location()

        };

    }
    / "__DIRECTORY__"i {

        return {

            type: 'StringLiteral',
            value: $tracker.dirpath(),
            location: location()

        };

    }
    / "__FILE__"i {

        return {

            type: 'StringLiteral',
            value: $tracker.filepath(),
            location: location()

        };

    }
    / "__MODULE__"i {

        return {

            type: 'StringLiteral',
            value: $tracker.moduleid(),
            location: location()

        };

    }
