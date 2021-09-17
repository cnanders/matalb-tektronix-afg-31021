[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));
cDirSrc = fullfile(cDirThis,  '..', 'src');
addpath(genpath(cDirSrc));


cDirMpm = fullfile(cDirThis, '..', 'mpm-packages');
addpath(genpath(cDirMpm));

comm = tektronix.AFG31021( ...
    'cTcpipHost', '192.168.20.38' ...
);
                
comm.turnOn5V();
delete(comm);