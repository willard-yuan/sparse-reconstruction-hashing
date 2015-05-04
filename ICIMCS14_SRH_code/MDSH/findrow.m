function [Ifind] = findrow(mat,rowvec )
% return all rows in mat that exactly match rowvec

Ifind=find((mat*rowvec')==(rowvec*rowvec'));



end

