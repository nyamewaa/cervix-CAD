
%VIA-
rneg=[198.5 212.41 174.85 197.73 198.98 122.33 150.87 212.03 146.21 191.67];
gneg=[116.87 134.84 136.1 132.47 139.56 122.66 79.76 142.64 107.89 112.91];
bneg=[171.84 180.27 163.37 179.15 180.63 127.21 103.86 165.4 115.79 164.78];

%VIA+
rpos=[225.53 203.01 206.71 185.99 205.3 196.57 126.108 163.49 244.42 128.33];
gpos=[158.81 118.42 119.01 108.19 146.63 165.85 119.712 160.15 166.11 112.13];
bpos=[216.52 173.77 151.1 169.17 192.88 175.86 135.92 170.94 193.76 118.22];

%Specref
rref=[241.54 234.39 251.25 254.58 250.6 253.57 254.89 253.98 250.96 254.39];
gref=[251.54 254.6 247.41 249.88 250.49 253.18 242.64 252.92 253.79 253.19];
bref=[254.06 243.27 253.73 249.88 254.04 254.87 254.74 254.91 254.07 253.55];

%transformation zone
rtrans=[130.05 206.72 221.74 247.08 174.95 196.77 181.28 255 176.41 164.99];
gtrans=[53.17 71.06 72.19 129.13 60.6 76 46.65 64.63 63.6 57.73];
btrans=[60.99 94.39 107.75 180.65 89.3 76 60.68 112.2 92.76 88.72];
figure;
scatter3(rneg,gneg,bneg)
hold on
scatter3(rpos,gpos,bpos,'*')
scatter3(rref,gref,bref,'<')
scatter3(rtrans,gtrans,btrans,'s')
hold off
legend('VIA-','acetowhitening','specular reflection','transformation zone')
xlabel('Red channel')
ylabel('Green channel')
zlabel('Blue channel')

figure
plot(rneg,'o')
hold on
plot(rpos,'*')
plot(rref,'<')
plot(rtrans,'s')
hold off