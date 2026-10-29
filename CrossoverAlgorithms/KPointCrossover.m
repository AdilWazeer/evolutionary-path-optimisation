function [chromosome1, chromosome2] = KPointCrossover(chromosome1, chromosome2, k)
    crossPoints = [sort(randperm(length(chromosome1) - 1, k)), length(chromosome1)]; % ascending order crosspoints
    for i = 1:2:length(crossPoints)-1
        l = crossPoints(i);
        r = crossPoints(i+1);
        [chromosome1(l:r), chromosome2(l:r)] = deal(chromosome2(l:r), chromosome1(l:r));
    end
end
