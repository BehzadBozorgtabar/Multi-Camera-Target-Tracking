function [H corrPtIdx] = findHomography(pts1,pts2)

coef.minPtNum = 4;
coef.iterNum = 30;
coef.thDist = 4;
coef.thInlrRatio = .1;
[H corrPtIdx] = ransac1(pts1,pts2,coef,@solveHomo,@calcDist);

end

function d = calcDist(H,pts1,pts2)

n = size(pts1,2);
pts3 = H*[pts1;ones(1,n)];
pts3 = pts3(1:2,:)./repmat(pts3(3,:),2,1);
d = sum((pts2-pts3).^2,1);

end
