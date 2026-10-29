function chromosome = GaussianNoiseMutation(chromosome, mutationRate, mutationFreq)
    if rand > mutationRate
        return;
    end
    sigma = 100; % fixed standard deviation
    i = randi([1, length(chromosome) - mutationFreq + 1]); % random index
    mutIdxs = i : i + mutationFreq - 1; % mutation index group
    mutatedPoints = round(chromosome(mutIdxs, :) + sigma * randn); % mean + sigma * (no of std's from mean)
    mutatedPoints(mutatedPoints < 1) = 1; % boundary check
    mutatedPoints(mutatedPoints > 500) = 500;
    chromosome(mutIdxs, :) = mutatedPoints;
end

