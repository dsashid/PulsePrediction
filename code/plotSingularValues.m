function []= plotSingularValues(s)
%PLOTSINGULARVALUES plots first ten normalized singular values, or percent variance
%  INPUTS: s: singular values from mean subtracted 

%range of singular values to plot
range_singValues = 1:10;

%bar plot of normalized singular values
figure(2)
bar(diag(s(range_singValues,range_singValues))./sum(diag(s)))

title('Normalized Singular Modes')
xlabel('Mode Number')
ylabel('Percent Variance')

end

