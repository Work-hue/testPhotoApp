function [mat] = joint_ht(pat, f1, f2)

    feat1 = pat.mats{1,f1};
    feat2 = pat.mats{1,f2};
    
    size_f1 = size(feat1,2);
    size_f2 = size(feat2,2);
    
    mat = zeros(size_f1*size_f2,6);
    
    % a and b are for loop variables
    % i and j are values at x[a] and y[b]
    
    for a = 1:size_f1
        for b = 1:size_f2
            
            row_num = (a-1)*size_f2+b;
            
            % fill in x=a and y=b
            mat(row_num,1) = feat1(1,a);
            mat(row_num,2) = feat2(1,b);
          
            % fill in p(x=i,y=j|h1) and p(x=i,y=j|h0)
            mat(row_num,3) = feat1(2,a)*feat2(2,b);
            mat(row_num,4) = feat1(3,a)*feat2(3,b);
            
            % fill in ML
            if(mat(row_num,3) >= mat(row_num,4))
                mat(row_num,5) = 1;
            else
                mat(row_num,5) = 0;
            end
            
            % fill in MAP
            if(mat(row_num,3)*pat.h1 >= mat(row_num,4)*pat.h0)
                mat(row_num,6) = 1;
            else
                mat(row_num,6) = 0;
            end 
        end
    end
end