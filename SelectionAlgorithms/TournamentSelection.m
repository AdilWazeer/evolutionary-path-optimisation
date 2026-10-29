
function choice = TournamentSelection(fitnessVec, tournamentSz)
    indices = randperm(length(fitnessVec), tournamentSz); % get random indices
    [~, maxIdxRelative] = max(fitnessVec(indices)); % get index of the best in the random tournament
    choice = indices(maxIdxRelative); % get absolute index
end
