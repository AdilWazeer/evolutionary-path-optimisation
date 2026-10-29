function chromosome = NoiseMutation(chromosome, mutationRate)
    if rand > mutationRate
        return;
    end
    p1 = randi(length(chromosome));
    p2 = randi(length(chromosome));
    while (p1 == p2)  % to make sure that p1 and p2 are different
        p2 = randi(length(chromosome));
    end
    if p1 > p2 % to make sure that p1 is smaller than p2
        [p1, p2] = deal(p2, p1);
    end
    chromosome(p1:p2) = fliplr(chromosome(p1:p2));
    
    noise = -1 + 2 * rand(length(chromosome), 1);
    chromosome = round(chromosome .* noise);
    chromosome(chromosome > 500) = 500;
    chromosome(chromosome < 1) = 1;
end 