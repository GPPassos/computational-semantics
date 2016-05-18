:- module(wordnetKnowledge,[]).

/*==================================
Use this in englishLexicon.pl:
==================================*/

:- consult('../wordnet/wn_s.pl')

lexEntry(noun,[symbol:Sym,syntax:[Expression]]) :-
    Ss_type = n,
    s(Synset,W_num,Word,Ss_type,_,_),
    checkWords([Word],[Expression]),
    atom_concat(Expression,Synset,Sym).

% Observe que ainda está errado: expressões de mesmo synset estão dando Syms distintos, mas gostaríamos que fosse igual.
% Ou podemos aceitar que serão distintos e criar um axioma de equivalência caso estejam no mesmo synset. Esta abordagem parece mais natural, mas talvez menos eficiente.
