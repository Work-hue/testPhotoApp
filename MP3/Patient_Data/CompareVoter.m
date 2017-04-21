function [probFalse, probMiss, probError] = CompareVoter(a, b)
    
    % "a" is the voter alarm array
    % "b" is the golden alarm array

    counterFalse = 0;
    counterMiss = 0;
    counterError = 0;
    
    for i = 1:size(a,2)
        if a(i) == 0 && b(i) == 1
            counterMiss = counterMiss + 1;
            counterError = counterError + 1;
        else if a(i) == 1 && b(i) == 0
            counterFalse = counterFalse + 1;
            counterError = counterError + 1;
            end
        end
    end
     
     probFalse = counterFalse/sum(b(:) == 0);
     probMiss = counterMiss/sum(b(:) == 1);
     probError = counterError/size(a,2);
end
    