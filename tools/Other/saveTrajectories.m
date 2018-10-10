function data = saveTrajectories( trajectories )

data = zeros(0,8);

for i = 1:length(trajectories)
    
    traj = trajectories(i);
    
    for k = 1:length(traj.tracklets)
       
        newdata = traj.tracklets(k).data;
        newdata(:,1) = i;
        data = [data; newdata];    
    end

end

