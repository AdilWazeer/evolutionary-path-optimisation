function [chromosome1, chromosome2] = UniformCrossover(chromosome1, chromosome2)
    swapPoints = rand(1, length(chromosome1)) < 0.5;
    [chromosome1(swapPoints), chromosome2(swapPoints)] = deal(chromosome2(swapPoints), chromosome1(swapPoints));
end