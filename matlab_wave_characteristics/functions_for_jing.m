% Tyler Banks 
% Functions for Jing
% 4/5/2018 11:39PM

infile = 'SampleSIZ_1.txt';
data = load(infile, '-ascii');
x = data(:,1); % column 1 of the data text file is assigned the variable x
y = data(:,2); % column 2 is assigned the variable y
hold on
title(infile)
plot(x,y)

peak_threshold = -10
spike_width = 200;

numberOfPeaks = num_spikes(y, peak_threshold)
slow_y = interp_spikes(y,peak_threshold,spike_width);
plot(x,new_y);

RMP = y(1) %get where the cell starts
spike_height = max(y) - RMP
slow_wave_depolarization_height = max(slow_y) - RMP

function y = interp_spikes(y, peak_threshold, spike_width)
    yg = y > peak_threshold; %find values above threshold
    %apply convolution to find values that meet the threshold and their surrounding points
    sumX = conv2(yg,ones(spike_width),'same');
    %find the indexes that aren't zero
    idx = sumX ~= 0;
    y(idx) = NaN;
    %interpolation over the NaN values
    y(isnan(y)) = interp1(find(~isnan(y)), y(~isnan(y)), find(isnan(y)),'PCHIP'); 
end

function n = num_spikes(y, peak_threshold)
    %Find number of spikes
    [L, n] = bwlabel(y>peak_threshold);
end
