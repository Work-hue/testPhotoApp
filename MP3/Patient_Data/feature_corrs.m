function [mat] = feature_corrs(patient)
    
    mat = zeros(7,7);
    for i = 1:7
        for j = 1:7
            tmp = corrcoef(patient.train_data(i,:),patient.train_data(j,:));
            mat(i,j) = tmp;
        end
    end
end