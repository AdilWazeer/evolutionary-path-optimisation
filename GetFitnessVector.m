function fitnessVec = GetFitnessVector(map, population, collisionPenalty, endpoints)
    originVec = repmat(endpoints(1), [height(population), 1, 2]); % height(population) copies of origin
    endVec = repmat(endpoints(end), [height(population), 1, 2]); % height(population) copies of end
    population = cat(2, originVec, population, endVec); % add origin and end points to each chromosome

    pathDistances = GetPathEuclideanDistances(population); % get path distances for each chromosome
    collideCnts = zeros(length(population), 1); % initialize collision count vector
    
    for i = 1:length(population)
        points = squeeze(population(i, :, :)); % current chromosome, each gene is a point in the path
        collisionCnt = 0;
        for j = 1:length(points)-1 
            collisionCnt = collisionCnt + CountObstacles(map, points(j, :), points(j+1, :)); % midpoints
        end
        collideCnts(i) = collisionCnt; % store collision count
    end

    % fitness function minimizes path length and number of collisions(emphasized more by collisionPenalty)
    fitnessVec = 1 ./ (pathDistances + collisionPenalty * collideCnts); % use inverse to minimize
end

function pathDistances = GetPathEuclideanDistances(population)
    differences = diff(population, 1, 2); % get differences between points 
    pointDistances = vecnorm(differences, 2, 3); % get the distance between each point for all paths
    pathDistances = sum(pointDistances, 2); % sum the distances for each path
end

function obstacleCnt = CountObstacles(map, p1, p2) % Bresenham's line algorithm to iterate through pixels between points
    obstacleCnt = 0; % initialize obstacle count
    x1 = p1(1);
    y1 = p1(2);
    x2 = p2(1);
    y2 = p2(2);

    dx = abs(x2 - x1);
    dy = abs(y2 - y1);
    sx = sign(x2 - x1);
    sy = sign(y2 - y1);
    err = dx - dy;

    while ~(x1 == x2 && y1 == y2) % starting point ignored, counted as end point in other segment
        e2 = 2 * err;

        if e2 > -dy
            err = err - dy;
            x1 = x1 + sx;
        end

        if e2 < dx
            err = err + dx;
            y1 = y1 + sy;
        end

        if (map(x1, y1) == 0)
            obstacleCnt = obstacleCnt + 1;
        end
    end
end
