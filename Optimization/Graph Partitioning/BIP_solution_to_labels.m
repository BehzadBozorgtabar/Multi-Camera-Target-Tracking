function [ labels ] = BIP_solution_to_labels( X, W )

labels = [1:size(W,1)]';
pos = 1;

for i = 1:size(W,1)
   
    for j = i + 1:size(W,1)
        
        if W(i,j)== -inf
            continue;
        end
       
        if X(pos)==1
            labels(j) = labels(i);
        end
        
        pos = pos + 1;
    end
end


ids = unique(labels);
tmplabels = labels;

for i = 1:length(ids)
    labels(tmplabels==ids(i)) = i;
end



