function cmap = makecmap(Nt)
% function cmap = makecmap(Nt)
%   Currently, set for makecmap(Nt), where Nt <= 7.
%   You can add more colors as you add tissues to makeTissueList.m.

cmap = zeros(64,3);
f1  = 0.7; % color adjustments
f2  = 0.5; % color adjustments
f3  = 0.3; % color adjustments

dj = 0.05;
for i=1:64
    j = round((i-dj)/64*(Nt-1));
    if      j<=1-dj, cmap(i,:)  = [ 1  1  1]; 
    elseif  j<=2-dj, cmap(i,:)  = [ 0 .4  1];
    elseif  j<=3-dj, cmap(i,:)  = [ 1  0  0];
    elseif  j<=4-dj, cmap(i,:)  = [ 1 .8 .8];
    elseif  j<=5-dj, cmap(i,:)  = [.5 .2 .2];
    elseif  j<=6-dj, cmap(i,:)  = [f1  1 f1]; % skull
    elseif  j<=7-dj, cmap(i,:)  = [f2 f2 f2]; % gray matter
    elseif  j<=8-dj, cmap(i,:)  = [.5  1  1]; % white matter
    elseif  j<=9-dj, cmap(i,:)  = [ 1 .5 .5]; % standard tissue
    elseif  j<=10-dj, cmap(i,:) = [.8 .4 .4]; % breast
    elseif  j<=11-dj, cmap(i,:) = [.7 .7 .7]; % tumor
    end
end
