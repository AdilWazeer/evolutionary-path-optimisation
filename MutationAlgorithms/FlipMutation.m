function chromosome = FlipMutation(chromosome, mutationRate)
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
end