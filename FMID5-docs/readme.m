      ***********************************************************
      *  Fuzzy Modeling and Identification Toolbox for MATLAB 5 *
      *             Version 3.02 April 2001                     *
      ***********************************************************

       Copyright (c) 1997-2001 Robert Babuska et.al., all rights reserved

Dr. Robert Babuska
Control Engineering Laboratory, Faculty of Information Technology and Systems
Delft University of Technology, Mekelweg 4, P.O. Box 5031, 2600 GA Delft
The Netherlands, Phone: +31 15 2785117, Fax: +31 15 2626738
E-mail: r.babuska@its.tudelft.nl, WWW: http://lcewww.et.tudelft.nl/~babuska

                *********************************
                ****      Installation       ****
                *********************************

The installation is straightforward and does not require any changes
to your system settings. Proceed along the following four steps:

1)    Create a subdirectory under your ...\MATLAB\TOOLBOX directory,
      call it whatever you like, for instance FMID. If you are updating
      an existing installation of the toolbox, remove all its files
      first.

2)    Copy the toolbox files to this directory. If the toolbox was
      provided as a zip file, use pkunzip to unpack it in this
      directory. Use the `-d' option in order to extract also the
      PRIVATE subdirectory which contains some utility functions used by
      the main toolbox routines.

3)    Modify or create the MATLAB's STARTUP.M file to include the FMID
      directory:
                    addpath c:\MATLAB\TOOLBOX\FMID

4)    Start MATLAB and run FMIDEMO.



                ****************************************
                ****       Printing the manual      ****
                ****************************************

The manual is produced in LaTeX. Two versions are provided in two
PostScript and PDF files.

a) FMIDMAN.PS (FMIDMAN.PDF) will print two pages on one A4.
b) FMIDMAN2.PS (FMIDMAN2.PDF) will produce a booklet (on a duplex
   printer).

If you need another format, contact the author, please.


        *********************************************************
        ****     Differences with respect to version 2.0     ****
        *********************************************************

--    The following functions have been added:
        -- FMTUNE   simplify membership functions and reduce the fuzzy model
        -- FMEST (re)estimates the consequent parameters in FM
        -- FMDOF compute the degree of fulfillment (much faster than FMSIM)
        -- PLOTDATA plot the data in Dat (time and scatter plots)
        -- PLOTPART plot the fuzzy partition obtained by FMCLUST
        -- PLOTOUT plot the output as function of individual inputs
        -- PLOTCONS plot the consequent as function of the cluster centers
        -- FMSORT sort rules in FM, using a given index vector
        -- FMUPGRADE upgrade FM from previous versions
        -- FM2WS export the fields of FM as variables to the workspace

--    With the required number of clusters set to 1 (Par.c = 1),
      FMCLUST will generate a MIMO linear model represented as
      coupled MISO models.

--    The DOF variable returned by FMSIM is now a cell array with the
      same structure as Ym and Ylm.

--    Multiple batches are not appended in the Dat structure
      anymore; they are rather specified as elements of a cell array,
      e.g., Dat.U{1}, Dat.U{2}, etc.

--    An optional filed "cons" has been added to FM. It is
      used to specify the parameter estimation method to be used
      (global, local, total, alpha-cut)

--    The synopsis of FMCLUST has been simplified. The user-defined
      parameters (clustering and dynamics) are now directly specified
      in FM. The fuzzy partition is returned in a structure along with
      the feature (data) matrix.

--    FM2TEX has been improved.

--    The possibilities in specifying the input and output lags
      and delays (Nu, Ny, Nd) have been extended.

--    The computation of the covariance matrix inverse in GK has been
      improved (conditioning warnings encountered with some data sets
      should no longer occur).

--    A bug has been fixed in FMCLUST (standard deviations of the
      consequent parameters are now computed correctly).

--    A bug has been fixed in FMSIM (simulation with Ny = 0 resulted in an
      error).

        *********************************************************
        ****     Differences with respect to version 2.1     ****
        *********************************************************

--    Various upgrades in the code to Release 12

--    A new syntax for defining the dynamics (see the files in the Demos directory)
      The old way still works as an interface, internally, the nwe one is used.  
