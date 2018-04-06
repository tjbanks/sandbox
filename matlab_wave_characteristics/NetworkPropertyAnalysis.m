% Tyler Banks 
% Functions for Jing
% 4/5/2018 11:39PM

infile = 'SampleSIZ_2.txt';
data = load(infile, '-ascii');
x = data(:,1); % column 1 of the data text file is assigned the variable x
y = data(:,2); % column 2 is assigned the variable y

figure()
hold on
title(infile)
plot(x,y)

peak_threshold = -10;
spike_width = 200;

RMP = y(x ==(100)) %get where the cell starts 
                   %Update(Jing): Skipped some points to avoid the effect of V_init

spike_height = max(y) - RMP  % in mV

numberOfPeaks = num_spikes(y, peak_threshold)
[slow_y,LCBD,SPBD,Latency] = BurstDurMeasure(x,y,peak_threshold,spike_width);

slow_wave_depolarization_height = max(slow_y) - RMP  % in mV

plot(x,slow_y); %Plot out the slow-wave oscillation


%Update(Jing): Changed the purpose to LC/SP Burst Duration & Latency Measurement
function [y,LCBD,SPBD,Latency] = BurstDurMeasure(x, y, peak_threshold, spike_width)
    yg = y > peak_threshold; %find values above threshold
    %apply convolution to find values that meet the threshold and their surrounding points
    sumX = conv2(yg,ones(spike_width),'same');
    %find the indexes that aren't zero
    idx = sumX ~= 0;
    y(idx) = NaN;
    
    %Calculate LC Burst Duration
    SpikeTime = x(idx);
    LCBD = SpikeTime(end)-SpikeTime(1) % in ms
    
    %Calculate SP Burst Duration & Latency
    yburst = y > y(x ==(100));
    yburst(x<100) = 0;  %Get rid of the effect of V_init
    BurstTime = x(yburst);
    SPBD = BurstTime(end) - BurstTime(1)  % in ms
    Latency = SpikeTime(1) - BurstTime(1) % in ms
    
    %interpolation over the NaN values
    %y(isnan(y)) = interp1(find(~isnan(y)), y(~isnan(y)), find(isnan(y)),'PCHIP'); 
end

function n = num_spikes(y, peak_threshold)
    %Find number of spikes
    [L, n] = bwlabel(y>peak_threshold);
end
