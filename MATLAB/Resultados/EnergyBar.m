function EnergyBar
x = categorical({'5V, I','5V, I, Ta','5V, 5Ir','5V, 5Ir, I, Ta','P&O'});
y=[7.1 7.1 6.5;5.9 7.9 6.7;10.5 11.2 11.1;10.4 11.0 11.1;0 10.8 0];
h=bar(x,y,'FaceColor','flat');
h(2).CData(5,:) = [.3 0 .5]; % P&O bar
title('Sombreado parcial')
xlabel('Modelo utilizado')
ylabel('Energía generada (Wh)')
set(gca,'FontSize',40);
end