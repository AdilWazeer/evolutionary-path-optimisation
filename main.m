% Genetic Algorithm for robot path planning.
% This version keeps the main evolutionary loop in this file and calls the
% selection, crossover, mutation, and fitness functions from their own files.
projectDir = fileparts(mfilename('fullpath'));
addpath(genpath(projectDir));

map = imbinarize(imread(fullfile(projectDir, 'random_map.bmp')));
[selectMode, crossMode, mutateMode] = GetInput();

% Hyperparameters for the genetic algorithm
noOfPointsInSolution = 30; % amount of turns allowed in the path
iter = 1000 + (max(0, noOfPointsInSolution - 20) * 5); % epochs to run the algorithm for, scales with #points
populationSize = 150; % number of chromosomes in each generation
collisionPenalty = 35; % penalty for colliding with each obstacle, further punishes collisions
eliteSize = ceil(0.3 * populationSize); % number of chromosomes to keep for next generation
mutationRate = 0.5; % chance of mutation occuring
crossoverRate = 0.8; % chance of c4rossover occuring
mutationFreq = ceil(0.3 * noOfPointsInSolution); % number of genes mutated, start high to explore space
checkpoint = round(iter * 0.6); % epoch point where hyperparameter adjustments are made to better adapt to search space

populationSize = populationSize + mod(populationSize - eliteSize, 2); % chromomes added 2 at a time, maintain even slots
tournamentSz = ceil(0.2 * populationSize); % number of chromosomes in each tournament, used in tournament selection
kPoint = 4; % number of crosspoints, used in k-point crossover 

populationRanks = populationSize:-1:1; % reverse ranks as fitness is ordered in decsending order
rankCumSum = cumsum(populationRanks / sum(populationRanks)); % used if rank based selection is chosen
tic; % start timer to measure how long the algorithm takes
% initialize population with random valid points (stored as [x, y]  in the 3rd dimension, excludes endpoints*) 
population = randi([1, length(map)], [populationSize, noOfPointsInSolution, 2]); % populationSize x noOfPoints x 2

for i = 1:iter % iterate through generations
    if i == checkpoint % switch to mutating fewer points to make fine grained changes to path
        mutationFreq = ceil(0.05 * noOfPointsInSolution); % set low num of points to be mutated at a time (min 1)
        crossoverRate = 0.5; % - crossover rate, less useful now that the search space has been narrowed down
        mutationRate = 0.9;  % + mutation rate, smaller search space & changes, so allow for more rapid exploration
    end
    fitnessVec = GetFitnessVector(map, population, collisionPenalty); % get all fitness scores 
    weightCumSum = cumsum(fitnessVec / sum(fitnessVec)); % used if roulette wheel selection is picked

    [~, sortedIndices] = sort(fitnessVec, 'descend'); % indices of sorted fitness scores, used to get sorted chromosomes
    new_population = zeros(size(population)); % new population to be filled with new chromosomes
    new_population(1:eliteSize, :, :) = population(sortedIndices(1:eliteSize), :, :); % keep eliteSize best chromosomes
    
    for j = (eliteSize + 1):2:populationSize % iterate through new population, adding 2 chromosomes at a time
        [select1, select2] = Selection(selectMode, fitnessVec, weightCumSum, sortedIndices, rankCumSum, tournamentSz); 
        path1 = squeeze(population(select1, :, :)); % squeeze to remove singleton dimensions
        path2 = squeeze(population(select2, :, :)); % use the selection method to get 2 chromosomes
        [path1, path2] = Crossover(crossMode, path1, path2, crossoverRate, kPoint); % attempt to crossover targets
        [path1, path2] = Mutation(mutateMode, path1, path2, mutationRate, mutationFreq); % attempt to mutate targets
        new_population(j, :, :) = path1; % add new chromosomes
        new_population(j + 1, :, :) = path2;
    end
    population = new_population; % replace old population with new population1
end

[~, solutionIdx] = max(GetFitnessVector(map, population, collisionPenalty)); % get best fitness score
solution = squeeze(population(solutionIdx, :, :)); % use to get best solution
DisplaySolution(map, solution); % display solution

function [selectMode, crossMode, mutateMode] = GetInput() % get user input for selection, crossover and mutation
    selectMode = input('Pick selection algorithm (1:Roulette Wheel / 2:Rank Based / 3:Tournament):  ');
    if selectMode < 1 || selectMode > 3 
        error('Invalid selection algorithm');
    end
    
    crossMode = input('Pick crossover algorithm (1:Uniform / 2:K-Point):  ');
    if crossMode < 1 || crossMode > 2
        error('Invalid crossover algorithm');
    end

    mutateMode = input('Pick mutation algorithm (1:Gaussian noise / 2:Uniform noise):  ');
    if mutateMode < 1 || mutateMode > 2
        error('Invalid mutation algorithm');
    end
end

function [select1, select2] = Selection(selectMode, fitnessVec, weightCumSum, sortedIndices, rankCumSum, tournamentSz)
    if selectMode == 1
        select1 = RouletteWheelSelection(weightCumSum);
        select2 = RouletteWheelSelection(weightCumSum);
    elseif selectMode == 2
        select1 = RankBasedSelection(sortedIndices, rankCumSum);
        select2 = RankBasedSelection(sortedIndices, rankCumSum);
    elseif selectMode == 3
        select1 = TournamentSelection(fitnessVec, tournamentSz);
        select2 = TournamentSelection(fitnessVec, tournamentSz);
    end
end

function [path1, path2] = Crossover(crossMode, path1, path2, crossoverRate, kPoint) % attempt crossover
    if rand() < crossoverRate
        if crossMode == 1
            [path1, path2] = UniformCrossover(path1, path2);
        elseif crossMode == 2
            [path1, path2] = KPointCrossover(path1, path2, kPoint); % 3 selection groups
        end
    end
end

function [path1, path2] = Mutation(mutateMode, path1, path2, mutationRate, mutationFreq) % attempt mutation
    if mutateMode == 1
        path1 = GaussianNoiseMutation(path1, mutationRate, mutationFreq);
        path2 = GaussianNoiseMutation(path2, mutationRate, mutationFreq);
    elseif mutateMode == 2
        path1 = UniformNoiseMutation(path1, mutationRate, mutationFreq);
        path2 = UniformNoiseMutation(path2, mutationRate, mutationFreq);
    end
end

function DisplaySolution(map, solution)
    fprintf('\nElapsed time: %.2f seconds\n', toc); % display time taken
    path = [[1, 1]; solution; size(map)]; % add origin and end points to path
    pathlen = ceil(sum(vecnorm(diff(path), 2, 2))); % get path length
    obstacleCnt = 0; % count obstacles in path
    for i = 1:length(path)-1 
        p1 = path(i, :);
        p2 = path(i+1, :);
        obstacleCnt = obstacleCnt + CountObstacles(map, p1(1), p1(2), p2(1), p2(2)); % count obstacles in segment
    end
    fprintf('Path length: %d cells\n', pathlen); % display path length
    fprintf('Collisions: %d cells\n', obstacleCnt); % display collision count


    clf; % display map and path
    imshow(map);
    rectangle('position',[1 1 size(map)-1],'edgecolor','k');
    line(path(:,2), path(:,1));
    title(['Collisions: ', num2str(obstacleCnt), ' cells', ', Path length: ', num2str(pathlen), ' cells']);
end

function obstacleCnt = CountObstacles(map, x1, y1, x2, y2) % Bresenham's algorithm to go through path counting obstacles
    obstacleCnt = 0; % initialize obstacle count

    dx = abs(x2 - x1); % absolute change in x and y
    dy = abs(y2 - y1);
    sx = sign(x2 - x1); % direction of change in x, -1 is left, 1 is right
    sy = sign(y2 - y1); % direction of change in y, -1 is down, 1 is up
    err = dx - dy; % error term, used to check if moving in x or y direction will keep the line close to the path

    while ~(x1 == x2 && y1 == y2) % while not at the end point
        e2 = 2 * err;  % used to check if moving in x or y direction will keep the line close to the path

        if e2 > -dy % move in x direction to stay on line
            err = err - dy;
            x1 = x1 + sx;
        end

        if e2 < dx % move in y direction to stay on line
            err = err + dx; 
            y1 = y1 + sy;
        end

        if (map(x1, y1) == 0) % if pixel is an obstacle
            obstacleCnt = obstacleCnt + 1; % increment obstacle count
        end
    end 
end % starting point ignored, counted as end point in previous segment, all paths have same origin so no need to count