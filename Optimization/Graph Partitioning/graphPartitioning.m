function [ X , objval ] = graphPartitioning( f, A, b, correlationMatrix, initialGuess )

partialSolution = f;
partialSolution(f == -inf) = 0;
partialSolution(f ~= -inf) = NaN;

if ~isempty(initialGuess)
	N = length(initialGuess);
	pos = 1;
	for i = 1:N-1
	    for j = i + 1:N
            if correlationMatrix(i,j) == -inf
                continue;
            end
            partialSolution(pos) = initialGuess(i) == initialGuess(j);
            pos = pos + 1;
	    end
	end
end


clear model;
model.obj = f;
model.A = sparse(A);
model.sense = '<';
model.rhs = b;
model.vtype = 'B'; % binary
model.modelsense = 'max';
model.start = partialSolution;
model.norelheuristic = 1;
clear params;

params.Presolve = 0;
params.outputflag = 0; 
result = gurobi(model, params);
objval = result.objval;
X = [result.x];




