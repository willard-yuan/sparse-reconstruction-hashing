function [retrievedItems,retrievedInds ] = retrieveNeighboringCodes(queryCode,Utest,deltas)
% create a list of retrieved items and indicators by returning all items
% whose codes are simialr to the query code and differ by one of the deltas
% Classic Semantic Hashing has delta be all the 1 sparse binary vectors
% deltas should be a matrix where each row is a binary delta vector



%retrievedInds=findrow(Utest,queryCode);
retrievedInds=[];

for ii=1:size(deltas,1)
    retrievedInds=[ retrievedInds; findrow(Utest,queryCode.*deltas(ii,:))];
end
retrievedItems=Utest(retrievedInds,:);


end

