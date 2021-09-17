classdef AFG31021Abstract < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    
    methods (Abstract)
        
        turnOn5V(this)
        turnOff5V(this)
        trigger5VPulse(this, dSec)
        l = getIsOn(this)
        
    end
    
    methods
        
               
    end
    
end

