%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                             Hlavní kód řešení                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% preliti(+Vstup:[Int-Int], -Vystup:[Int-Int], +P2-P1:Int-Int, -A2-A1:Int-Int)
%
% Vybere dvě nádoby ze Vstup tak aby přelití dávalo smysl a nejednalo se
% o stejné jako v předchozím kroku v opačném pořadí a aplikuje na ně naplnZ.
%
% @param Vstup původní seznam nádob a jejich kapacit
% @param Vystup výsledný seznam nádob a jejich kapacit
% @param P2-P1 odkud kam se přelévalo v předchozím kroku
% @param A2-A1 odkud kam se přelévalo v aktuálním kroku

preliti(Vstup, Vystup, P2-P1, A2-A1):-
    select(V1-C1, Vstup, Temp),
    V1 \= C1,
    select(V2-C2, Temp, Temp2),
    V2 \= 0,
    nth1(A1, Vstup, V1-C1),
    nth1(A2, Vstup, V2-C2),
    (
        A1 \= P2
    ;
        A2 \= P1
    ),
    preliti_x(V1, V2, C1, Vv1, Vv2),
    nth0(I1, Vstup, V1-C1),
    nth0(I2, Temp, V2-C2),
    nth0(I2, Temp3, Vv2-C2, Temp2),
    nth0(I1, Vystup, Vv1-C1, Temp3).


% přelití z nádoby V2 do nádoby V1 až po kapacitu C

preliti_x(V1, V2, C1, Vv1, 0) :- 
    V1 + V2 =< C1,
    Vv1 is V1 + V2.

preliti_x(V1, V2, C1, C1, Vv2) :-
    V1 + V2 > C1,
    Vv2 is V2 - (C1 - V1).


%% vyres(+Vstup:[Int-Int], +Vystup:[Int-Int], -P:[[Int-Int]], -P2:[Int-Int])
%
% Nalezne posloupnost stavů nádob a posloupnost přelití mezi Vstup a Vystup
%
% @param Vstup původní seznam nádob a jejich kapacit
% @param Vystup výsledný seznam nádob a jejich kapacit
% @param P posloupnost stavů nádob
% @param P2 posloupnost přelití 

vyres(Vstup, Vystup, P, P2):-
    otestuj(Vstup, Vystup),
    odhad_min_kroku(Vstup, Vystup, OdhadMin),
    odhad_max_kroku(Vstup, OdhadMax),
    between(OdhadMin, OdhadMax, L), 
    length(P, L), 
    vyres_x(Vstup, Vystup, P, P2),
    !.

vyres_x(Vstup, Vystup, [Vstup | P], P2) :-
    vyres_xx(Vstup, Vystup, [], [0-0], P, [_ | P2]).


vyres_xx(Vstup, Vstup, A, A2, P, P2) :-
    reverse(A, P),
    reverse(A2, P2).

vyres_xx(Vstup, Vystup, A, [A2 | A2s], P, P2):- 
    preliti(Vstup, M, A2, A2v),
    \+ member(M, A),
    vyres_xx(M, Vystup, [M | A], [A2v, A2 | A2s], P, P2).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%        Pomocný kód pro ošetření vadných zadání a odhady složitosti         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% odhady

odhad_min_kroku([], [], 0).

odhad_min_kroku([V-_ | Vss], [V-_ | Vys], Odhad):-
    odhad_min_kroku(Vss, Vys, Odhad),
    !.

odhad_min_kroku([V1-_ | Vss], [V2-_ | Vys], Odhad):-
    V1 \= V2,
    odhad_min_kroku(Vss, Vys, Odhad1),
    Odhad is Odhad1 + 1.


odhad_max_kroku(Vstup, Odhad):-
    length(Vstup, Delka),
    soucet_objemu(Vstup, _, Soucet),
    fac(Delka + Soucet, F1),
    fac(Delka, F2),
    fac(Soucet, F3),
    Odhad is F1 / ( F2 * F3 ).


fac(0, 1).

fac(N, F):-
    N > 0,
    N1 is N - 1,
    fac(N1, F1),
    F is N * F1,
    !.


% testování vstupů

otestuj(Vstup,Vystup):-
    soucet_objemu(Vstup, SVs, CVs),
    soucet_objemu(Vystup, SVy, CVy),
    assertion(SVs == SVy, 'Celkovy objem vstupu neroven objemu vystupu.'),
    assertion(SVs =< CVs, 'Celkovy objem vstupu prevysuje kapacitu vstupu.'),
    assertion(SVy =< CVy, 'Celkovy objem vystupu prevysuje kapacitu vystupu.'),
    assertion(kontrolaNadob(Vstup, Vystup), 'Nadoby maji ruzne kapacity.'),
    assertion(nepreplnene(Vstup),'Nektera nadoba na vstupu je preplnena'),
    assertion(nepreplnene(Vystup),'Nektera nadoba na vystupu je preplnena').


assertion(Condition, Error) :-
    (
       Condition,
       !
    ;
       throw(error(Error))
    ).


soucet_objemu([], 0, 0).

soucet_objemu([V-C | Vs], Sv, Sc) :-
    soucet_objemu(Vs, Sv1, Sc1),
    Sv is V + Sv1,
    Sc is C + Sc1.


kontrolaNadob([], []).

kontrolaNadob([_-C | Vss], [_-C | Vys]):-
    kontrolaNadob(Vss, Vys).


nepreplnene([]).

nepreplnene([V-C | Vs]):-
    V =< C,
    nepreplnene(Vs).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         Sada testovacích příkladů, na následujícím řádku je zdroj.         %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

problem(1, [8-8, 0-5, 0-3], [4-8, 4-5, 0-3]).

problem(2, [12-12, 0-8, 0-5], [6-12, 6-8, 0-5]). 
% https://puzzling.stackexchange.com/questions/54750/filling-water-jugs

problem(3, [10-10, 0-5, 0-6], [8-10, 0-5, 2-6]). 
% https://puzzling.stackexchange.com/questions/25900/water-jugs-10-5-and-6-v2