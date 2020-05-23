// Wrapper around petscsys.h
//
//

import std.algorithm, std.array, std.string;

public import mpi.mpi;
public import petsc.c.error; // Error handling interface
public import petsc.c.types;

alias MPI_COMM_SELF PETSC_COMM_SELF;

immutable PETSC_DECIDE = -1;

//PetscCopyMode  - Determines how an array passed to certain functions is copied or retained
enum PetscCopyMode { COPY_VALUES, OWN_POINTER, USE_POINTER};

extern(C) {
  PetscErrorCode PetscInitialize(size_t*,char***,const char*,const char*);
  PetscErrorCode PetscFinalize();
  
  // Simple PETSc parallel IO for ASCII printing
  PetscErrorCode PetscPrintf(MPI_Comm,const char*,...);
  PetscErrorCode PetscSynchronizedPrintf(MPI_Comm,const char*,...);
  PetscErrorCode PetscSynchronizedFlush(MPI_Comm);
  PetscErrorCode PetscGetPetscDir(const char**);
  
  PetscErrorCode PetscSleep(PetscReal);
}

extern(C) {
  extern __gshared MPI_Comm PETSC_COMM_WORLD;
}

// A wrapper to convert D's arguments to C style
// and handle ierr
void PetscInitialize(string[] args, string help="", string file = __FILE__, size_t line = __LINE__) {  
  size_t argc = args.length;
  char** argv = cast(char**) array(map!toStringz(args)).ptr;

  // Initialize PETSc
  int ierr = PetscInitialize(&argc, &argv, null, help.ptr);
  if(ierr)
    throw new Exception("Failed to initialize PETSc", file, line);

  // Get the MPI global variables
  MPI_Get_globals();
}

///////////////////////////////////////////////////////////////
// Simple parallel IO for ASCII printing
//
///////////////////////////////////////////////////////////////

//PetscErrorCode PetscWrite(MPI_Comm,const char*,


