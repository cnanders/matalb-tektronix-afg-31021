[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));
cDirSrc = fullfile(cDirThis,  '..', 'src');
addpath(genpath(cDirSrc));


cDirMpm = fullfile(cDirThis, '..', 'mpm-packages');
addpath(genpath(cDirMpm));

comm = tektronix.AFG31021Virtual();
                
comm.turnOn5V();


% delete(comm);