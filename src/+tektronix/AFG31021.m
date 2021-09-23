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
        
        cSourceType
        
        
    end
    
    methods
        
        function this = AFG31021(varargin) 
            
            % Call superclass constructor
            this = this@AsciiComm(varargin{:});
            
            % Defaults
            this.cConnection = this.cCONNECTION_TCPCLIENT;
            this.u16TcpipPort = uint16(5025); % support said this will work;
            this.cSourceType = this.cSOURCE_TYPE_NONE;
            this.u8TerminatorWrite = uint8([10]);
            this.u8TerminatorRead = uint8([10]);
            
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
            
            if ~strcmpi(this.cSourceType, this.cSOURCE_TYPE_DC)
                this.configureFor5VDC()
            end
            
            this.writeAscii('VOLTAGE:OFFSET 5');
        end
        
        function turnOff5V(this)
            
            if ~strcmpi(this.cSourceType, this.cSOURCE_TYPE_DC)
                this.configureFor5VDC()
            end
            
            this.writeAscii('VOLTAGE:OFFSET 0');
        end
        
        function trigger5VPulse(this, dSec)
                        
            %{
            if this.getIsOn()
                fprintf('tektronix.AFG31021.trigger5VTTLPulse returning since already outputting 5VTTL\n');
                return
            end
            %}
            
            if ~strcmpi(this.cSourceType, this.cSOURCE_TYPE_PULSE)
                this.configureFor5VPulse()
            end
            
            
            cCmd = sprintf('PULSe:PERiod %1.3fs', dSec);
            this.writeAscii(cCmd);
            this.writeAscii('*TRG'); % geterate a trigger event to trigger the "burst" of one pulse
            
            
            
        end
        
        function l = getIsOnDC(this)
            this.writeAscii('VOLTAGE:OFFSET?');
            c = this.readAscii();
            
            % convert to double
            
            dVal = str2double(c);
            dTol = 1e-3; 
            dGoal = 5;
            
            if (...
                dVal > dGoal - dTol && ...
                dVal < dGoal + dTol ...
            )
                l = true;
            else
                l = false;
            end
            
            
            
        end
        
        function l = getIsOnPulse(this)
            
            this.writeAscii('STATUS:OPER:COND?');
            c = this.readAscii();
            
            switch c
                case '0'
                    l = true;
                otherwise
                    l = false;
            end
            
        end
        
        
        function l = getIsOn(this)
              
            
            switch this.cSourceType
                case this.cSOURCE_TYPE_DC
                    l = this.getIsOnDC();
                case this.cSOURCE_TYPE_PULSE
                    l = this.getIsOnPulse();
                otherwise
                    l = this.getIsOnDC();
            end

            
        end
        
    
                
    end
    
    methods (Access = private)
        
        function configureFor5VPulse(this)
            
            this.writeAscii('FUNCtion:SHAPe Pulse');
            this.writeAscii('BURSt:STATe ON');
            this.writeAscii('BURSt:NCYCles 1');
            this.writeAscii('PULSe:DCYCle 99.999'); % not allowed to set to 100
            this.writeAscii('VOLT:AMPL 5');
            this.writeAscii('VOLT:OFFS 2.5');
            this.writeAscii('TRIG:SOUR EXT'); % external trigger (we will use force API)
            this.writeAscii('TRIG:SLOP NEG'); % negative slope
            this.writeAscii('OUTPUT ON');
            this.writeAscii('BURS:IDLE START'); % after burst ends, take value it had before it started
            
            this.cSourceType = this.cSOURCE_TYPE_PULSE;

            
        end
        
        function configureFor5VDC(this)
            
            this.writeAscii('FUNCTION DC');
            this.writeAscii('OUTPUT ON');

            this.cSourceType = this.cSOURCE_TYPE_DC;

            
        end
        
        
    end
    
    
    
   

end


