% use set_prolog_flag(answer_write_options,[max_depth(0)]).
problem(1,[8-8,0-5,0-3], [4-8,4-5,0-3]).
problem(2,[12-12,0-8,0-5], [6-12,6-8,0-5]). % https://puzzling.stackexchange.com/questions/54750/filling-water-jugs
problem(3,[10-10,0-5,0-6], [8-10,0-5,2-6]). % https://puzzling.stackexchange.com/questions/25900/water-jugs-10-5-and-6-v2
problem(k, [9-10,7-10,6-7,5-7,0-7,0-7],[9-10,2-10,2-7,2-7,5-7,7-7]).
problem(n,[10-10,10-10,0-10,0-10,0-7,7-7,7-7],[9-10,5-10,5-10,0-10,5-7,5-7,5-7]).

% preliti(+Vstup1,+Vstup2,-Vystup1,-Vystup2).
preliti(V1,V2,C1,Vv1,Vv2) :- V1 + V2 =< C1, Vv1 is V1+V2, Vv2 = 0.
preliti(V1,V2,C1,Vv1,Vv2) :- V1 + V2 > C1, Vv1=C1, Vv2 is V2 -(Vv1-V1).
% preliti(V1-C1,V2-C2,Vv1-C1,Vv2-C2) :- V1 + V2 =< C1, Vv1 is V1+V2, Vv2 = 0.
% preliti(V1-C1,V2-C2,Vv1-C1,Vv2-C2) :- V1 + V2 > C1, Vv1=C1, Vv2 is V2 -(Vv1-V1).
% preliti(V1-C1,V2-C2,Vv1-C1,Vv2-C2) :- V1 + V2 =< C2, Vv2 is V1+V2, Vv1 = 0.
% preliti(V1-C1,V2-C2,Vv1-C1,Vv2-C2) :- V1 + V2 > C2, Vv2=C2, Vv1 is V1 -(Vv2-V2).

preliti(Vstupni, Vystupni, Pre2-Pre1, Akt2-Akt1):-
    select(V1-C1,Vstupni,Temp),
    V1\=C1,
    select(V2-C2,Temp, Temp2),
    V2\=0,
    nth1(Akt1,Vstupni,V1-C1),
    nth1(Akt2,Vstupni,V2-C2),
    (Akt1\=Pre2;Akt2\=Pre1),
    preliti(V1,V2,C1,Vv1,Vv2),
    nth0(I1,Vstupni,V1-C1),
    nth0(I2,Temp,V2-C2),
    nth0(I2,Temp3,Vv2-C2,Temp2),
    nth0(I1,Vystupni,Vv1-C1,Temp3),
    Vstupni\=Vystupni.

vyres_(Z,K,[Z|P],P2) :- vyres_(Z,K,[],[0-0],P, [_|P2]).
vyres_(Z,Z,A,A2,P,P2) :- reverse(A, P), reverse(A2,P2).

vyres_(Z,K,A,[A2|A2s],P, P2):- preliti(Z,M, A2,A2v),\+ member(M,A),vyres_(M,K,[M|A],[A2v,A2|A2s],P, P2).

vyres(Z,K,P,P2, I):- between(I,inf,L), length(P, L), vyres_(Z,K,P, P2).
