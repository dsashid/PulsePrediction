function [u,s,v] = calculateSingularValues(Xtotal)
%CALCULATESINGULARVALUES: calculates singular values from mean subtracted data

%Take SVD of whole train set
[u,s,v]=svd(Xtotal-mean(Xtotal(:)),'econ');

end

