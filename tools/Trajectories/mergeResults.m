function [ mergedResult ] = mergeResults( result1, result2 )

maximumLabel = max(result1.labels);

if isempty(maximumLabel)
    maximumLabel = 0;
end

mergedResult.labels = [result1.labels; maximumLabel + result2.labels];
mergedResult.observations = [result1.observations;result2.observations];


