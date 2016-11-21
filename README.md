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

A compiled PDF of the published example files can be found [here](examples/html/index.pdf)

#### Simple Beam (beam1.st7 model)
(in no particular order)
5. [assign nodal restraints](examples/html/beam1_restraints.html) - apply nodal restraints to beam boundary conditions.

1. [linear transient solver - nodal load](examples/html/beam1_lsa.html) - use the linear transient solver to pull nodal displacements due to a 1kip point load at DOF3.

2. [natural frequency analysis](examples/html/beam1_nfa.html) - assign fixed-fixed boundary conditions and perform a natural frequency analysis. frequencies, mode shapes, and mass participation are extracted.

3. [assign discrete springs to the beam](examples/html/beam1_springs.html) - assign discrete springs to the beams boundary nodes

6. [spring stiffness sensitivity study](examples/html/beam1_sensitivitystudy.html) - perform a sensitivity study of a rotational spring applied at the pinned end of the simply-supported beam. track and plot the changes in the natural frequencies.

4. [update spring values based on natural frequencies](examples/html/beam1_optimization.html) - a random spring stiffness is generated and assigned to the pinned end of a simply-supported beam. a natural frequency analysis is performed and used as the 'experimental' data. particle swarm optimization is then used to update the spring value based on the first three natural frequencies obtained by the 'experiment'

7. [Property mass sensitivity study] - perform a sensitivity study on density of material assigned to beam property. Track and plot the changes in the natural frequencies.

8. [Nodal Mass Sensitivity Study] - perform a sensitivity study on adding non-structural mass to select nodes. Track and plot the changes in the natural frequencies.

9. [Beam property section sensitivity study] - perform a sensitivity study of the beam's moment of inertia (I11). Track and plot the changes in the natural frequencies.

#### Simple plate model (plate1.st7)

1. [Plate density sensitivity study] - perform a sensitivity study of the density of a plate property.

2. [Plate thickness sensitivity study] - perform a sensitivity study of the plate property thickness.

#### Simple bridge model (grid1)

1. [Update Parameters based on natural frequency results] - perform an updating run of select parameters so as to match the model natural frequency results with experimental frequencies and mode shapes.


## Dependencies

[visual modal analysis - vma](https://github.com/johndevitis/vma)
