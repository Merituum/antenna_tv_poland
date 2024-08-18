clear;
clc;
% n=input("Podaj ilosc dipoli: ");
% dl_last=input("Podaj dlugosc najdłuższego dipola: ");
% tau=input("Podaj tau: ");
n=12;
dl_last=93.75;
tau=0.83;
sigma=0.234*tau-0.051;
% disp(sigma);
fprintf("Sigma wynosi: %f \n",sigma);

wymiary=zeros(1,n);
wymiary(1)=dl_last;
odleglosci=zeros(1,n);

for i=2:n
    wymiary(i)=dl_last*0.83;
    % disp(" ");
    
    
    dl_last=dl_last*tau;
end
% disp("Wymiary: ");
% disp(wymiary);

odleglosci(1)=((wymiary(1)-wymiary(2))/2)*(4*sigma/(1-tau));
% disp("odleglosci: ");
for x=2:n
    odleglosci(x)=odleglosci(x-1)*0.83;
end
% disp(odleglosci);
for y=1:n
    fprintf("Długość dipola nr %d = %f, odległość od poprzedniego dipola wynosi: %f \n",y,wymiary(y),odleglosci(y));
end