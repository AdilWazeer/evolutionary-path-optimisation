function chromosome = UniformNoiseMutation(chromosome, mutationRate, mutationFreq) % 
    if rand > mutationRate
        return;
    end
    range = 200;
    i = randi([1, length(chromosome) - mutationFreq + 1]); % random index
    mutIdxs = i : i + mutationFreq - 1; % mutation indices
    mutatedPoints = chromosome(mutIdxs, :) + round(2 * range * rand - range); % mutate
    mutatedPoints(mutatedPoints < 1) = 1; % check bounds
    mutatedPoints(mutatedPoints > 500) = 500;
    chromosome(mutIdxs, :) = mutatedPoints; % update chromosome
end
