function chromosome = ValueMutation(chromosome, mutationRate)
    if rand > mutationRate
        return;
    end
    upperBound = 500;
    lowerBound = 1;
    change = 8; % change in value

    mut_idx = randi([1, length(chromosome)]);
    if rand < 0.5
        if chromosome(mut_idx) > upperBound - change
            chromosome(mut_idx) = chromosome(mut_idx) - change;
        else
            chromosome(mut_idx) = chromosome(mut_idx) + change;
        end
    else
        if chromosome(mut_idx) < lowerBound + change
            chromosome(mut_idx) = chromosome(mut_idx) + change;
        else
            chromosome(mut_idx) = chromosome(mut_idx) - change;
        end
    end
end
