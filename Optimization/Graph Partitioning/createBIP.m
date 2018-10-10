function [ f, A, b ] = createBIP( W )

N = size(W,1);


f = zeros(N*(N-1)/2,1);


pairs = zeros(N,N-1);

pos = 1;
for i = 1:N-1
    for j = i + 1:N
        pairs(i, j) = pos; 
        f(pos) = W(i,j);
        pos = pos + 1;
    end
end


if N>=3
    triples = combnk(1:N,3);

    idx = zeros(size(triples));

    idx(:,1) = pairs(sub2ind(size(pairs), triples(:,1),triples(:,2))); 
    idx(:,2) = pairs(sub2ind(size(pairs), triples(:,1),triples(:,3)));
    idx(:,3) = pairs(sub2ind(size(pairs), triples(:,2),triples(:,3)));
    idx_x3 = kron(idx,[1 1 1]');
    permutations = idx_x3;
    permutations(2:3:end,:)=circshift(idx_x3(2:3:end,:)',1)';
    permutations(3:3:end,:)=circshift(idx_x3(3:3:end,:)',2)';

    idx = permutations';

    rows = kron(1:(size(triples,1)*3),[1,1,1])';
    cols = idx(:);
    values = kron(ones(size(triples,1)*3,1),[1 1 -1]');

    % A - constraints matrix
    A = sparse(rows,cols,values);
    b = ones(size(A,1),1);
    

    infIndices = pairs(W==-inf);
    infIndices(infIndices==0) = [];
    
    A(:,infIndices) = []; 
    f(infIndices) = [];
    
elseif N == 2

    % No constraints
    A = sparse([0]);
    b = [0];

else 

    % N is 0 or 1
    A = sparse([0]);
    b = [0];
    f = W;
end





