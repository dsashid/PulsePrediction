function [] = createHistograms(v,n_pulse)
%CREATEHISTOGRAMS plots histograms of temporal modes with pulse/no pulse
%labels
%   INPUTS: v: temporal modes
%n_pulse: cutoff for pulse labels


figure(8)

count = 1 ;

for j=1:3
        P1 = subplot(3,1, count)
        %plot histograms of temporal modes with pulseless labels
        g = histfit(v(n_pulse:n_pulse*2,j),70);
        hold on 
        %plot histogram of temporal modes with pulse labels
        h = histfit(v(1:n_pulse,j),70);

        %formatting figure
        set(h(1),'FaceColor', [153,213,148]/255)
        set(g(1),'FaceColor',[10 10 255]/255)
        set(h(1),'FaceAlpha',.8);
        set(g(1),'FaceAlpha',.8);
        h(2).Color = [.2 .2 .2];
        g(2).Color = [.2 .2 .2];

        legend([g(1),h(1)],'Pulseless','Pulse')

        set(gca, 'Fontsize',20)
        yt = get(gca, 'YTick');
        set(gca, 'YTick', yt, 'YTickLabel', round(yt/n_pulse,2))

        %center axes on histogram
        if count ==1
                set(P1, 'XLim', [0 .06])
        else
                set(P1, 'XLim', [-.1 .1])   
        end

        count = count+1;
end


end

