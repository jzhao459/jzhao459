function d = bi2de(b, secondArg, thirdArg)
    %BI2DE Convert binary vectors to decimal numbers.
    %   D = BI2DE(B) converts a binary vector B to a decimal value D. When B is
    %   a matrix, the conversion is performed row-wise and the output D is a
    %   column vector of decimal values. The default orientation of the binary
    %   input is Right-MSB; the first element in B represents the least
    %   significant bit.
    %
    %   In addition to the input matrix, two optional parameters can be given:
    %
    %   D = BI2DE(...,P) converts a base P vector to a decimal value.
    %
    %   D = BI2DE(...,MSBFLAG) uses MSBFLAG to determine the input orientation.
    %   MSBFLAG has two possible values, 'right-msb' and 'left-msb'.  Giving a
    %   'right-msb' MSBFLAG does not change the function's default behavior.
    %   Giving a 'left-msb' MSBFLAG flips the input orientation such that the
    %   MSB is on the left.
    %
    %   Examples:
    %       B = [0 0 1 1; 1 0 1 0];
    %       T = [0 1 1; 2 1 0];
    %
    %       D = bi2de(B)
    %       E = bi2de(B,'left-msb')
    %       F = bi2de(T,3)
    %
    %   See also DE2BI.
    
    %   Copyright 1996-2020 The MathWorks, Inc.
    
    arguments
        b (:,:) {mustBeNumericOrLogical, mustBeNonempty, mustBeInteger, mustBeNonnegative}
        % Default MSB orientation
        secondArg = 'right-msb'
        % Default base
        thirdArg = 2
    end
    
    % Input validation
    [b_double, inType, p, msbFlag] = validateInputs(b, secondArg, thirdArg);
    
    d = comm.internal.utilities.bi2de(b_double, p, msbFlag, inType);
    
end

function [b, inType, p, msbFlag] = validateInputs(b, secondArg, thirdArg)
    
    inType = class(b);
    % All internal processing is done in double representation
    b = double(b);  
        
    if comm.internal.utilities.isCharOrStringScalar(secondArg)
        
        if ~any(strcmp(secondArg, {'left-msb', 'right-msb'}))
            error(message('comm:bi2de:InvalidMSBFlag'));
        end
        msbFlag = secondArg;
        
        if ~isequal(thirdArg, 2)
            validateattributes(thirdArg, {'numeric'}, {'scalar', ...
                'integer', '>', 1}, '', 'base p', 3);
        end
        % Set up the base to convert from.
        p = thirdArg; 
        
    elseif isnumeric(secondArg)
        
        if ~isequal(secondArg, 2)
            validateattributes(secondArg, {'numeric'}, {'scalar', ...
                'integer', '>', 1}, '', 'base p', 2);
        end
        % Set up the base to convert from.
        p	= secondArg; 
        
        if comm.internal.utilities.isCharOrStringScalar(thirdArg)
            if ~any(strcmp(thirdArg, {'left-msb', 'right-msb'}))
                error(message('comm:bi2de:InvalidMSBFlag'));
            end
            msbFlag = thirdArg;
        else
            if ~isequal(thirdArg, 2)
                error(message('comm:bi2de:InvalidInputArg'));
            end
            msbFlag = 'right-msb';
        end
        
        
    else
        error(message('comm:bi2de:InvalidInputArg'));
    end
    
    if max(max(b(:))) > (p-1)
        error(message('comm:bi2de:InvalidInputElement'));
    end
end
