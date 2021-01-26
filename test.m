X = [18 20 22 24 26 27 28 30];
peppers = [1116.72 642.68 425.64 393.64 300 265.64 265.64 265.64];
lena = [872.59 546.56 384.99 384.99 300.99 256.99 256.99 256.99];
figure(1)
plot(X,log2(peppers),X,log2(lena));
title('2D Fast Fourier Transform Error')
legend('Peppers','Lena')

Z = [9 10 12 14 16 18 20 22]
p1 = [422 352.39 251.68 161.87 141.26 13.26 13.26 13.26]
l1 = [406.5 348.73 238.45 150.7 141.09 13.09 13.09 13.09]
figure(2);
plot(Z,log2(p1),Z,log2(l1));
title('1D Fast Fourier Transform Error')
legend('Peppers','Lena')
