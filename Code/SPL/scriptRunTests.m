plys = cell(10,1);
plys{1}  = 'C:\eduardo\Sequences\andrew9\ply\frame0000.ply';
plys{2}  = 'C:\eduardo\Sequences\andrew9\ply\frame0001.ply';
plys{3}  = 'C:\eduardo\Sequences\david9\ply\frame0000.ply';
plys{4}  = 'C:\eduardo\Sequences\david9\ply\frame0001.ply';
plys{5}  = 'C:\eduardo\Sequences\phil9\ply\frame0000.ply';
plys{6}  = 'C:\eduardo\Sequences\phil9\ply\frame0001.ply';
plys{7}  = 'C:\eduardo\Sequences\ricardo9\ply\frame0000.ply';
plys{8}  = 'C:\eduardo\Sequences\ricardo9\ply\frame0001.ply';
plys{9}  = 'C:\eduardo\Sequences\sarah9\ply\frame0000.ply';
plys{10} = 'C:\eduardo\Sequences\sarah9\ply\frame0001.ply';

titles = cell(10,1);
titles{1}  = 'Andrew Frame 0';
titles{2}  = 'Andrew Frame 1';
titles{3}  = 'David Frame 0';
titles{4}  = 'David Frame 1';
titles{5}  = 'Phil Frame 0';
titles{6}  = 'Phil Frame 1';
titles{7}  = 'Ricardo Frame 0';
titles{8}  = 'Ricardo Frame 1';
titles{9}  = 'Sarah Frame 0';
titles{10} = 'Sarah Frame 1';



matFiles = cell(10,1);
matFiles{1}  = 'andrew_frame0000.mat';
matFiles{2}  = 'andrew_frame0001.mat';
matFiles{3}  = 'david_frame0000.mat';
matFiles{4}  = 'david_frame0001.mat';
matFiles{5}  = 'phil_frame0000.mat';
matFiles{6}  = 'phil_frame0001.mat';
matFiles{7}  = 'ricardo_frame0000.mat';
matFiles{8}  = 'ricardo_frame0001.mat';
matFiles{9}  = 'sarah_frame0000.mat';
matFiles{10} = 'sarah_frame0001.mat';


for (m = 1:1:10)
    filename = plys{m};
    matFile  = matFiles{m};
    
    load(matFile)
    x = [resultsA(:,1) resultsB(:,1) resultsC(:,1)];
    y = [resultsA(:,2) resultsB(:,2) resultsC(:,2)];
    z = [resultsA(:,3) resultsB(:,3) resultsC(:,3)];
    
    pc = pcread(filename);
    
    rateA = resultsA(9,2) / pc.Count;
    rateB = resultsB(9,2) / pc.Count;
    rateC = resultsC(9,2) / pc.Count;
    
    str = sprintf('%1.4f\t%1.4f\t%1.4f',rateA,rateB,rateC);
    disp(str)
    
    figure;
    %subplot(3,1,1)
    %bar(x)
    %ylabel('Number of Symbols Encoded')
    %xlabel('Depth')
    %legend('Method A','Method B','Method C','Location','NorthWest')
    
    
    
    subplot(2,1,1)    
    bar(z)
    title(titles{m})
    ylabel('Time Elapsed (Seconds)')
    xlabel('Depth')
    legend('Method A','Method B','Method C','Location','NorthWest')
    
    subplot(2,1,2)    
    bar(y)
    title(titles{m})
    ylabel('Rate (Number of Bits)')
    xlabel('Depth')
    legend('Method A','Method B','Method C','Location','NorthWest')
    keyboard;
    %script_Tests;
end
