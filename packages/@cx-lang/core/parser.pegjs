{

    const positiontracker = tracker.create( input, {

        filename: options.filename,
        detailsCache: peg$posDetailsCache

    } );
    peg$computePosDetails = positiontracker.compute;
    peg$computeLocation = positiontracker.generate;

}

start
  = DefinitionSource
  / ScriptSource
  / ProgramSource
  / ModuleSource
