function [f inlierIdx] = ransac1( x,y,ransacCoef,funcFindF,funcDist )


minPtNum = ransacCoef.minPtNum;
iterNum = ransacCoef.iterNum;
thInlrRatio = ransacCoef.thInlrRatio;
thDist = ransacCoef.thDist;
ptNum = size(x,2);
thInlr = round(thInlrRatio*ptNum);

inlrNum = zeros(1,iterNum);
fLib = cell(1,iterNum);

for p = 1:iterNum
	% 1. fit using  random points
	sampleIdx = randIndex(ptNum,minPtNum);
	f1 = funcFindF(x(:,sampleIdx),y(:,sampleIdx));
	
	% 2. count the inliers, 
	dist = funcDist(f1,x,y);
	inlier1 = find(dist < thDist);
	inlrNum(p) = length(inlier1);
	if length(inlier1) < thInlr, continue; end
	fLib{p} = funcFindF(x(:,inlier1),y(:,inlier1));
end

% 3. choose the coef with the most inliers
[~,idx] = max(inlrNum);
f = fLib{idx};
dist = funcDist(f,x,y);
inlierIdx = find(dist < thDist);
	
end
