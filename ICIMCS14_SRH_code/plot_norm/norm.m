clear
clc
subplot(111)
num = 5;
matrix = 5*rand(num, num)-1;
matrix(2, :)=[0.001, 0.002, 0.001, 0.003, 0.009];
matrix(4, :)=0;
% matrix = [0, 1.7493, 1.5662, 0, 3.7239;
%     -0.2732, 0, 1.0090, 2, 1.4543;
%     0, 3.2652, 1.5863, 0, 1.4463;
%     3.3465, 2.1103, 0, -0.7517, 0.6886;
%     1.8985, 0, 2.5, 0, 3.5003];
imagesc(1 : num, 1 : num, matrix);
axis off
caxis([-1, 4]);
colorbar('EastOutside');