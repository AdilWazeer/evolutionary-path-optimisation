function choice = RankBasedSelection(sortedIndices, rankCumSum)
    p = rand(); % random number between 0 and 1 on a uniform distribution
    for i = 1:length(rankCumSum) - 1 % -1 as last element is 1, so will always be greater than p
        if (rankCumSum(i) > p) % find first index where rankCumSum > random number
            choice = sortedIndices(i); % return index of chromosome with that rank
            return;
        end
    end
    choice = sortedIndices(end); % if no index found, return last index (last rank)
end