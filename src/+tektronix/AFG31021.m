classdef AFG31021 < tektronix.AFG31021Abstract & AsciiComm
    
    properties
    end
    
    properties (Constant)
        
        cSOURCE_TYPE_DC = 'DC';
        cSOURCE_TYPE_PULSE = 'PULSE';
        cSOURCE_TYPE_NONE = 'NONE';
                
    end
    
    properties
        
        
    end
    
    properties (Access = private)
        
        dSensitivity = 5; % this is not a value, it is one of the 30 allowed values on the hardware
        lHasSet = false;
        
        cSourceType
        
    end
    
    methods
        
        function this = AFG31021(varargin) 
            
            % Call superclass constructor
            this = this@AsciiComm(varargin{:});
            
            % Defaults
            this.cConnection = this.cCONNECTION_TCPCLIENT;
            this.u16TcpipPort = uint16(5005); % visa;
            
            % Overwrite with params
            for k = 1 : 2: length(varargin)
                this.msg(sprintf('passed in %s', varargin{k}));
                if this.hasProp( varargin{k})
                    this.msg(sprintf('settting %s', varargin{k}));
                    this.(varargin{k}) = varargin{k + 1};
                end
            end
            
            this.init(); % AsciiComm.init()
            
        end
           
        
        function turnOn5V(this)
            this.writeAscii('VOLTAGE:OFFSET 5');
        end
        
        function turnOff5V(this)
            this.writeAscii('VOLTAGE:OFFSET 0');
        end
        
        function trigger5VPulse(this, dSec)
            
            if this.getIsOn()
                fprintf('tektronix.AFG31021.trigger5VTTLPulse returning since already outputting 5VTTL\n');
                return
            end
            
            switch this.cSourceType
                case this.cSOURCE_TYPE_DC
                    this.configureFor5VPulse()
          
            end
            
            
            cCmd = sprintf('SOURce1:PULSe:PERiod %1.3es', dSec);
            this.writeAscii(cCmd);
            this.writeAscii('*TRG'); % trigger the "burst" of one pulse
            
            
            
        end
        
        function l = getIsOn(this)
                        
            c = this.readAscii('STATUS:OPER:COND?');
            
            switch c
                case '0'
                    l = true;
                otherwise
                    l = false;
            end
            
            
        end
        
    
                
    end
    
    methods (Access = private)
        
        function configureFor5VPulse(this)
            
            this.writeAscii('SOURce1:FUNCtion:SHAPe Pulse');
            this.writeAscii('SOURce1:BURSt:STATe ON');
            this.writeAscii('SOURce1:BURSt:NCYCles 1');
            this.writeAscii('SOURce1:PULSe:DCYCle 100');
            this.writeAscii('OUTPUT ON');
            
            this.cSourceType = this.cSOURCE_TYPE_PULSE;

            
        end
        
        function configureFor5VDC(this)
            
            this.writeAscii('FUNCTION DC');
            this.writeAscii('OUTPUT ON');

            this.cSourceType = this.cSOURCE_TYPE_DC;

            
        end
        
        
    end
    
    
    
   

end


