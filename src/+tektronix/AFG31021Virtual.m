classdef AFG31021Virtual < tektronix.AFG31021Abstract
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % Requires port 5555
        
        
    end
    
    properties (Access = private)
        
        % {logical 1x2} true when the hardware is outputting 5V.  One 
        % value for each channel
        lIsOn = [false false]
        
        
        % {timer 1x1} - storage for timers used in the trigger method to
        % update the value of lIsOn of each channel
        t1
        t2
        
        u8Ch = 1;  % I'm using the rigol class and modifying it for 1-ch hardware
    end
    
    methods
        
        
        function this = AFG31021Virtual(varargin) 
                        
            for k = 1 : 2: length(varargin)
                this.msg(sprintf('passed in %s', varargin{k}));
                if this.hasProp( varargin{k})
                    this.msg(sprintf('settting %s', varargin{k}));
                    this.(varargin{k}) = varargin{k + 1};
                end
            end
            
        end
        
        function c = idn(this)
            c = 'AFG31021Virtual';
        end
        
        % @return {logical 1x1} - true if outputting 5VTTL or if in the 
        % middle of communication between requesting 5VTTL and knowing 100%
        % that the 
        function l = getIsOn(this)
            l = this.lIsOn(this.u8Ch);
        end
        
        % Create a single 5 Volt TTL pulse of specified duration in
        % seconds
        % @param {double 1x1} dSec - pulse duration in seconds
        
        function turnOn5V(this)
            this.lIsOn(this.u8Ch) = true;
        end
        
        function turnOff5V(this)
            this.lIsOn(this.u8Ch) = false;
        end
        
        function trigger5VPulse(this, dSec)
            
            if this.lIsOn(this.u8Ch) == true
                fprintf('rigol.AFG31021Virtual.trigger5VTTLPulse returning since already outputting 5VTTL\n');
                return
            end
            
            this.lIsOn(this.u8Ch) = true;
                        
            this.t1 = timer(...
                'StartDelay', dSec, ...
                'TimerFcn', @this.onTimer1 ...
            );
            start(this.t1);
            
                        
        end
        
        
    end
    
    methods (Access = private)
        
        function onTimer1(this, src, evt)
            this.lIsOn(1) = false;
        end
        
        function onTimer2(this, src, evt)
            this.lIsOn(2) = false;
        end
        
                
    end
    
end

