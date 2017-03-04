% !! Write a funcion for calculating and ploting pdf and CDF of X    
function  pdf_cdf(X)       
    % !! Find the possible values of Y
    Y = floor(X);
    Floors = unique(floor(X));
    
    % !! Calculate the PMF of Y 
    max_Y = Floors(size(Floors,2));
    min_Y = Floors(1);
    Freqs = hist(Y,max_Y-min_Y+1);
    Pmf = Freqs/size(X,2);
    
    % !! Bar Plot the PMF of Y
    subplot(2,1,2);
    
    x = min_Y:1:max_Y;
    bar(x,Pmf);
    
    hold on; % For the next plots to be on the same figure
    
    % Plot the estimated PDF of X using Kernel Density Estimation
    % See the following links for more information on kernel density estimation based on data:
    % http://en.wikipedia.org/wiki/Kernel_density_estimation
    % http://www.mathworks.com/help/stats/kernel-distribution.html 
    %pd = fitdist(X', 'kernel', 'Kernel', 'box');
    %xi = floor(min(X)):1:floor(max(X));
    %yi = pdf(pd, xi);
    %plot(xi, yi, 'LineWidth', 2, 'Color', 'g');hold on;
    %hold on;  % For the next plots to be on the same figure
    
    % !! Calculate and plot CDF of X - First hold on subplot(2,1,1)
    %subplot(2,1,1); hold on;
end
    

    
    
   
    
   