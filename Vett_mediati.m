%% Sottrae ad un insieme di vettori il singolo vettore di ugual dimensione Vett_medio
function VM = Vett_mediati( dimensione_vett, numero_vett, V, Vett_medio)
%%Se i vettori che compongono V avessero dimensione diversa da Vett_medio
%%bisognerebbe restituire un errore

%VM = vettori a cui viene tolto Vett_medio
VM = ones(dimensione_vett, numero_vett);
for i = 1 : numero_vett
    VM( :, i) = V( :, i) - Vett_medio;
end

