function [cor_mat] = feature_corrs(pat)
    
    cor_mat = zeros(7,7);

    for i = 1:7
        for k = 1:7
            data1 = pat.train_data(i,:);
            data2 = pat.train_data(k,:);
            cor = corrcoef(data1, data2);
            cor_mat(i,k) = abs(cor(1,2));
        end
    end
end