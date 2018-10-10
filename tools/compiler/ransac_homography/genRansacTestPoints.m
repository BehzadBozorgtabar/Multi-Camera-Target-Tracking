function [ pts ] = genRansacTestPoints( ptNum,outlrRatio,inlrStd,inlrCoef )


outlrNum = round(outlrRatio*ptNum);
inlrNum = ptNum-outlrNum;

k = inlrCoef(1);
b = inlrCoef(2);
X = (rand(1,inlrNum)-.5)*ptNum; 
Y = k*X+b;

% add noise for inliers
dist = randn(1,inlrNum)*inlrStd;
theta = atan(k);
X = X+dist*(-sin(theta));
Y = Y+dist*cos(theta);
inlrs = [X;Y];

outlrs = (rand(2,outlrNum)-.5)*ptNum;
pts = [inlrs,outlrs];

end

