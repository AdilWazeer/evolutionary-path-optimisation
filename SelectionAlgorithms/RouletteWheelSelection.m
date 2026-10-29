function choice = RouletteWheelSelection(weightCumSum)
    p = rand(); % random number between 0 and 1 on a uniform distribution
    for i = 1:length(weightCumSum) - 1 % -1 as last element is 1, so will always be greater than p
        if (weightCumSum(i) > p) % find first index where weightCumSum > random number
            choice = i; % return index of chromosome with that weight
            return;
        end
    end
    choice = length(weightCumSum); % if no index found, return last index (last weight)
end
