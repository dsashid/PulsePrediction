function [HRvec,median_interval_vec,ecgDataFiltered,locs_filt_new] =heartRateDetector(inputClips)
%HEARTRATE DETECTOR
%note: outputs changed so can graph
%   Inputs:
%inputClips: inputs filtered clips
%Outputs:
%HRvec: heart rates for each of the clips
%median_interval_vec:  median interval for each clip in seconds

%make a vector with heart rates/med_intervals

%noPulse 
[~, col] = size(inputClips);                    
HRvec = zeros(col,1);            
median_interval_vec = zeros(col,1);
universalSR = 250;

%%


%First doing HR_vec_CPR_noPulse

                        %ASK ABOUT K = 4: pulse without CPR
                        
                   for k =1:col
                       mat = inputClips(:,k);
                       clear locs_filt_new;
                       tau = 15;
                       counter = 0;
                       
                       %run high order filter with higher first cutoff 
                        ecgFiltOrder = 4;   % Order
                        ecg_Fc1 = 10;
                        ecg_Fc2 = 40;  % Second Cutoff Frequency
                        fs_butter = universalSR;
                        % Construct an FDESIGN object and call its BUTTER method.
                        h_butter  = fdesign.bandpass('N,F3dB1,F3dB2', ecgFiltOrder, ecg_Fc1, ecg_Fc2, fs_butter);
                        Hd_butter = design(h_butter, 'butter');
                        ecgDataFiltered = filtfilt(Hd_butter.sosMatrix, Hd_butter.scaleValues, mat);
                        
                        set(0,'defaulttextinterpreter','latex');  
                        set(0, 'defaultAxesTickLabelInterpreter','latex');  
                        set(0, 'defaultLegendInterpreter','latex');

                         
                         %TODO: take med of top 4 and then 1/2 for min peak
                         %height
                        [pks,locs,w,p]= findpeaks(ecgDataFiltered,'MinPeakDistance', floor(.25*universalSR));
                        pks_sorted = sort(pks, 'descend');
                        median_peak_height = median(pks_sorted(1:5));
                        min_peak_height = .3* median_peak_height;
                        
                        [pks_filt,locs_filt,w_filt,p_filt]= findpeaks(ecgDataFiltered,'MinPeakDistance', floor(.25*universalSR),'MinPeakHeight', min_peak_height);
                        %hacky way to plot
%                         findpeaks(ecgDataFiltered,'MinPeakDistance', floor(.25*universalSR),'MinPeakHeight', min_peak_height)
%                         xlabel('Detected Peak Location Times (s)')
%                         xticks([0:250:length(noPulsemat(:,k))])
%                         xticklabels(split(string(0:17)))
%                         ylabel('Filtered Wave Value')
%                         title('Find peaks with higher band frq')
                        
                        for kk = 1:length(locs_filt)
                            length_to_beginning = locs_filt(kk)-1;
                            length_to_end = length(mat)- locs_filt(kk);
                            
                            if peak2peak(mat(locs_filt(kk)-min(tau,length_to_beginning):locs_filt(kk)+min(tau, length_to_end)))>.2
                                counter = counter+1;
                               locs_filt_new(counter) = locs_filt(kk);
                            else locs_filt_new = zeros(length(locs_filt),1);
                            end
                            
                        end 
                        
                        
                        hold on
%                         plot(locs_filt_new, ecgDataFiltered(locs_filt_new),'ro')
                        %TODO: find median peak height and compare to .08
                        
                        median_interval_vec(k) = median(diff(locs_filt_new))/universalSR;
                        %calculate width of psd QRS?, might need actual QRS
                        med_dist = median(w_filt);
                        
                        %calculate HR using various clips (both CPR/no CPR)
                        sec_in_min  = 60;
                        num_beats = length(locs_filt_new);
                       
                        num_sec_in_clip = floor((length(inputClips)/universalSR));
                        factor = sec_in_min/num_sec_in_clip;
                        heartrate =num_beats*factor;
                        
                        HRvec(k) = heartrate;
%                         
%                         figure(6)
%                         plot(ecgDataFiltered)
%                         plot(locs_filt_new,ecgDataFiltered(locs_filt_new),'rx')

                        
                        
                        %% test : want to see correlation between median interval for CPR vs. no CPR
                        
                        
                   end

end

