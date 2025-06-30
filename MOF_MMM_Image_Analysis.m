%% MOF_MMM_Image_Analysis.m
%
% Description:
% This script stitches together a 4×4 grid of bright-field microscope images,
% processes the composite image to detect single MOF particles and clusters,
% and estimates total particle counts within mixed-matrix membranes (MMMs).
% It also produces visual outputs including binary images, labeled images,
% and histograms of estimated particles per cluster.
%
% Requirements:
% - MATLAB with Image Processing Toolbox
% - Image files stored in the specified folder, named in the format: '240_row_col_BF.png'
%
% Author: Adedire Adesiji
% Date: 30-Jun-2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% User-Defined Parameters
gridSize = 4;  % Grid size (number of rows and columns)
imageFolder = fullfile(pwd, '070824', '240');  % Directory containing images

% Particle size thresholds (pixels)
minArea = 200;
maxArea = 2000;
clusterThreshold = 2000;

%% Image Stitching: Combine Images into Composite
compositeImage = [];

for row = 1:gridSize
    rowImages = [];
    for col = 1:gridSize
        filename = sprintf('240_%d_%d_BF.png', row, col);
        fullPath = fullfile(imageFolder, filename);
        
        if ~isfile(fullPath)
            warning('File not found: %s', fullPath);
            continue;
        end
        
        img = imread(fullPath);
        
        % Convert to grayscale if RGB
        if size(img, 3) == 3
            img = rgb2gray(img);
        end
        
        rowImages = cat(2, rowImages, img);
    end
    compositeImage = cat(1, compositeImage, rowImages);
end

%% Image Processing: Filtering and Thresholding
filteredImage = medfilt2(compositeImage, [3, 3]);
adaptiveThresh = adaptthresh(filteredImage, 0.35, ...
    'ForegroundPolarity', 'dark', 'Statistic', 'mean');
binaryImage = ~imbinarize(filteredImage, adaptiveThresh);

%% Particle Labeling and Area Analysis
labeledImage = bwlabel(binaryImage);
particleProps = regionprops(labeledImage, 'Area', 'PixelIdxList');
allAreas = [particleProps.Area];

% Identify single particles and clusters
singleIdx = find(allAreas >= minArea & allAreas <= maxArea);
clusterIdx = find(allAreas > clusterThreshold);
numSingles = numel(singleIdx);
clusterAreas = allAreas(clusterIdx);

% Calculate average single particle area
if ~isempty(singleIdx)
    avgSingleArea = mean(allAreas(singleIdx));
else
    avgSingleArea = NaN;
    warning('No single particles detected in specified area range.');
end

% Estimate number of particles per cluster
if ~isnan(avgSingleArea) && avgSingleArea > 0
    estParticlesPerCluster = round(clusterAreas / avgSingleArea);
else
    estParticlesPerCluster = zeros(size(clusterAreas));
end

totalClusterParticles = sum(estParticlesPerCluster);
totalParticles = numSingles + totalClusterParticles;

%% Visualization
% Binary Image
figure; imshow(binaryImage);
title('Binary Image after Adaptive Thresholding');

% Stitched Composite with Grid
figure; imshow(compositeImage);
title('Stitched Composite Image with Grid');
hold on;
[numRows, numCols, ~] = size(img);
for k = 1:gridSize-1
    xline(k * numCols, 'Color', 'red', 'LineWidth', 2);
    yline(k * numRows, 'Color', 'red', 'LineWidth', 2);
end
hold off;

% Color-Labeled Particles
coloredLabels = zeros(size(labeledImage,1), size(labeledImage,2), 3, 'uint8');
for k = 1:length(particleProps)
    idx = particleProps(k).PixelIdxList;
    if ismember(k, singleIdx)
        coloredLabels(idx + 0*numel(labeledImage)) = 0;
        coloredLabels(idx + 1*numel(labeledImage)) = 255;  % Green
        coloredLabels(idx + 2*numel(labeledImage)) = 0;
    elseif ismember(k, clusterIdx)
        coloredLabels(idx + 0*numel(labeledImage)) = 255;  % Red
        coloredLabels(idx + 1*numel(labeledImage)) = 0;
        coloredLabels(idx + 2*numel(labeledImage)) = 0;
    end
end

figure; imshow(coloredLabels);
title('Labeled Particles (Green: Singles, Red: Clusters)');

% Histogram of Particles per Cluster
figure;
histogram(estParticlesPerCluster, 'BinWidth', 1);
title('Estimated Particles per Cluster');
xlabel('Estimated Number of Particles');
ylabel('Frequency');

%% Summary Output
disp(['Standalone Particles: ', num2str(numSingles)]);
disp(['Number of Clusters: ', num2str(numel(clusterAreas))]);
disp(['Estimated Total Particles in Clusters: ', num2str(totalClusterParticles)]);
disp(['Total Estimated Particles: ', num2str(totalParticles)]);
if ~isnan(avgSingleArea)
    disp(['Average Single Particle Area (pixels): ', num2str(avgSingleArea, '%.2f')]);
    disp(['Average Particles per Cluster: ', num2str(mean(estParticlesPerCluster, 'omitnan'), '%.2f')]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
