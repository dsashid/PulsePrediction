function [] = plotTemporalModes(v, n_pulse)
%PLOTTEMPORALMODESL plots temporal modes for pulse/no pulse labels

%INPUTS:
%v: temporal modes from SVD:
%n_pulse: cutoff for number of pulse labels


%plot/project first three modes for pulse and no pulse labels
plot3(v(1:n_pulse,1),v(1:n_pulse,2),v(1:n_pulse,3),'o','MarkerEdgeColor','k',...
'MarkerFaceColor',[156 240 9]/255 ,'MarkerSize',8), grid on
hold on

plot3(v(n_pulse+1:end,1),v(n_pulse+1:end,2),v(n_pulse+1:end,3),'o','MarkerEdgeColor','k',...
'MarkerFaceColor','b','MarkerSize',8), grid on
     

%Format figure
axis([-.1 .1 -.1 .1 -.1 .1]);
xlabel('Mode 1' )
ylabel('Mode 2')
zlabel('Mode 3')
legend('Pulse', 'No Pulse')

end

