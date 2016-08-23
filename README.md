# st7api
a collection of strand7 api utilities and templates

> run the init.m script from anywhere to add all files to the matlab search path

## Setup
To get the Stran7 API working you need Stran7 installed (with the license configured) and a 32-bit version of Matlab.
* **Matlab** - Newer versions of Matlab don't require any setup, but older versions (circa 2011) need a default compiler to be selected (done with `mex -setup`).

* **Strand7** - The path to the Strand7 executable need to be in your namespace. For Windows machines, copy/paste the full path into your environmental variables. The path is usually located here: `C:\Program Files (x86)\Strand7 R24\Bin`

## Contents

### The API Shell
The Strand7/Matlab API needs some boiler plate code to run and handle errors correctly. Typically this takes the form of a try/catch statement which calls a main function:
```
function apiCalls()
  try
    apiInit();
    results = main(input);
    apiClose();
  catch
    apiForceClose();
    rethrow(lasterror);
  end
end

function results = main(input)
  % do some things...
end

```

`apish.m` handles this boiler plate code and acts as a self-contained wrapper for executing your main function.

Refactoring the above code using apish becomes:
```
fcn = @main; % create a function handle
results = apish(fcn,inputs);
```

### Examples

A compiled PDF of the published example files can be found [here](johndevitis.github.io/st7api/examples/html/index.pdf)

#### Simple Beam
1. [assign boundary conditions to beam](examples/html/beam_restraints.html)
2. [natural frequency analysis](examples/beam1_nfa.html)
3. [assign discrete springs to the beam](examples/beam1_springs.html)
