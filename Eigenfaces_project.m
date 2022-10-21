%%%BODY del programma di riconoscimento facciale (Costruzione del DataBase
%%%ottimizzato

function EigenData = Body2()
%% Caricamento DataBase (scegliendone la grandezza N) e visualizzazione 
load('ORL_FaceDataSet.mat')

N = 40; %%numero di foto da utilizzare
%%vediamo le foto come matrici di 
Righe = 112;
Colonne = 92;

MiniData = VisualizzazioneDataBase(N, ORL_FaceDataSet);   %%Utilizziamo solo una porzione del DataBase

%% Creazione delle eigenfaces

%%srotolamento delle N facce in N vettori (VI = vettori immagine)
VI = Srotolamento(N, MiniData);

%%calcoliamo la faccia media (=FM)
FM = mean(VI.').';

%%togliamo ai vettori immagine la faccia media (VM = vettori mediati)
VM = ones(Righe*Colonne, N);
for i = 1 : N
    VM( :, i) = VI( :, i) - FM;
end

%%calcoliamo la matrice di covarianza ( calcolare gli autovettori di C non è
%%pratico, allora finchè N << 10304 possiamo calcolare gli autovettori u(i)
%%di C tramite la relazione u(i)=VM*v(i) dove v(i) sono gli autovettori 
%%della matrice A = (VM' * VM) 
%%(EVA = eigenvector di A, AV = autovalori di A, EV = eigenvalues di C)
C = 1/N * (VM * VM'); 
[EVA, AV] = eig(VM' * VM);
EV = VM * EVA;
%%normalizziamo le eigenfaces
for i = 1 : N
    EV(:,i) = EV(:,i) / norm(EV(:,i));
end

%%visualizziamo le eigenfaces (EF = eigenfaces)
EF = reshape( EV, Righe, Colonne, N);

%%visualizziamo le eigenfaces
figure
for i = 1:N
    subplot(floor(N/10)+1,10, i), imagesc(EF(:,:,i)), colormap gray(256);

end

%% Ottimizzazione
%%Riduciamo la dimensione dello spazio delle facce
%%Creiamo una matrice che ha come prima riga l'autovalore di C e sul resto
%%della colonna il corrispettivo autovettore
B = [ diag(AV)'; EV];
%%SAV = (somma di tutti gli autovalori)
SAV = sum(AV);
%%riordiniamo in ordine decrescente gli autovalori con i rispettivi
%%autovettori
[AV,D] = sort( diag(AV), 'descend');
EV = EV(:,D);
%%calcoliamo quanto sarà grande la base dello spazio delle facce con
%%un'approssimazione del 95%
%%sum_AV = somma di tutti gli autovalori
sum_AV = sum(AV);
AUX = (cumsum( AV / sum_AV) < 0.95);
%%M = numero di autofacce rimanenti
%%calcolo di M
M = 1;
while AUX(M) == 1
    M = M + 1;
end
%%ridimensioniamo gli autovettori e gli autovalori
AV = AV( 1 : M);
EV = EV( :, 1 : M);

%% Rappresentazione delle immagini nello "spazio delle facce"
%%prendiamo ogni faccia del database e la proiettiamo sullo spazio delle
%%facce, in questo modo avremo vettori M dimensionali invece di vettori
%%10304 dimensionali
%%DC = database compresso
DC = (VM' * EV)';

%% Divisione DataBase in classi di facce diverse
%%%Il DataBase è formato da N foto di P persone differenti, supponiamo che
%%%(come nel caso d'esempio) il DataBase sia ordinato per persona, cioè
%%%prima tutte le foto della prima persona, poi tutte le foto della seconda
%%%persona etc.. e che ogni persona abbia lo stesso numero di foto nel
%%%DataBase
%%%sia NFP = numero foto per persona
%%%per ogni classe creiamo la faccia media che rappresenta la specifica
%%%persona all'interno della classe
%%%il numero P di persone nel DataBase è NP = ([N/NFP] + 1) (parte intera del
%%%numero di foto per persona + 1)
%%%CP = matrice che ha per colonna la faccia media di ogni singola classe
%%%Al momento ogni persona deve avere esattamente lo stesso numero di
%%%foto(si può migliorare)
NFP = 10;
NP = ceil(N/NFP);
CP = ones(M,NP);

for j = 1 : NP
        for m = 1 : M
            CP(m,j) = sum(DC(m, (j-1)*NFP+1 : (j-1)*NFP+NFP));
        end
end

CP = (CP / NP)';

EigenData = DC;
