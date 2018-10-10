function labels = solveBIP( correlationMatrix, initialGuess )

[f, A, b] = createBIP(correlationMatrix);

[X, ~] = graphPartitioning(f, A, b, correlationMatrix, initialGuess);


labels = BIP_solution_to_labels(X, correlationMatrix);


