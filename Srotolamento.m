%%n = quantità di dati
%%MiniData = DataBase in formato di matrice tridimensionale in cui l'ultimo
%%elemento fa da indice 
function Srot = Srotolamento(Righe, Colonne, n, MiniData)


SEV2 = ones(Righe*Colonne, n);

for i = 1 : n
    SEV = MiniData(:,:,i);
    SEV2(:,i) = SEV(:);
end

Srot = SEV2;

end