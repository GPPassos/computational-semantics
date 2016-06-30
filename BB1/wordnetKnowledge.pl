:- module(wordnetKnowledge,[wordnetKnowledge/3]).

/*==================================
Use this in englishLexicon.pl:
==================================*/
/*
:- consult('../wordnet/wn_s.pl')
:- use_module(readLine,[checkWords/2]).

lexEntry(noun,[symbol:Sym,syntax:[Expression]]) :-
    Ss_type = n,
    s(Synset,W_num,Word,Ss_type,_,_),
    checkWords([Word],[Expression]),
    atom_concat(Expression,Synset,Sym).
*/

% There are two ways to think about it:
% a) Perhaps we would like that different expressions with the same meaning correspond to the same symbol in the logical expression. 
% b) However, we could accept different expressions with the same meaning corresponding to different symbols. Then equivalence axioms could be inserted. Perhaps this is less efficient computationaly, but it works.

% We use (b).

/*==================================
Use synsets, if not already loaded
==================================*/

:- if(source_file('kellerStorage.pl')).
:- import(kellerStorage:s/6).
:- else.
:- consult('../wordnet/wn_s.pl').
:- endif.
%:- load_files('kellerStorage.pl',imports(s/6),
%:- import(kellerStorage:s/6); ensure_loaded('../wordnet/wn_s.pl'). %wordnetKnowledge:import(X:s/6).
:- consult('../wordnet/wn_hyp.pl').
:- use_module(readLine,[checkWords/2]).
%:- (\+ source_file('../wordnet/wn_s.pl')) -> consult('../wordnet/wn_s.pl'); (s(A,B,C,D,E,F) -> assert(wordnetKnowledge:s(A,B,C,D,E,F))).

synonym(Sym1,Sym2) :- % Input: Sym1; Output: Sym2, where Sym2 is a synonym of Sym1
    atom_concat(E1,Synset,Sym1),
    atom_number(Synset,SynsetNum),
    s(SynsetNum,_,Word,_,_,_),
    checkWords([Word],[E2]),
    \+ E1 = E2,    
    atom_concat(E2,Synset,Sym2).

hypernym(Sym1,Sym2) :- % Apenas dá hiperônimos diretos, não dá todos os antecedentes na árvore.
    atom_concat(E1,Synset,Sym1),
    atom_number(Synset,SynsetNum),
    hyp(SynsetNum,SynsetHyp),
    s(SynsetHyp,_,Word,_,_,_),
    checkWords([Word],[E2]),
    \+ E1 = E2,    
    atom_concat(E2,SynsetHyp,Sym2).


%s(Synset,W_num,Expression,Ss_type,_,_)

/*==================================
Synonyms from Wordnet
==================================*/

wordnetKnowledge(Sym,Arity,Axiom) :-
    synonym(Sym,Sym2),
    (
        Arity = 0, Axiom = eq(Sym,Sym2)
    ;
        Arity = 1, F1 =.. [Sym,X], F2 =.. [Sym2,X], Axiom = all(X,and(imp(F1,F2),imp(F2,F1)))
    ;
        Arity = 2, F1 =.. [Sym,X,Y], F2 =.. [Sym2,X,Y], Axiom = all(X,all(Y,and(imp(F1,F2),imp(F2,F1))))
    ).    

wordnetKnowledge(Sym,Arity,Axiom) :-
    hypernym(Sym,Sym2),
    (
        Arity = 1, F1 =.. [Sym,X], F2 =.. [Sym2,X], Axiom = all(X,imp(F1,F2))
    ;
        Arity = 2, F1 =.. [Sym,X,Y], F2 =.. [Sym2,X,Y], Axiom = all(X,all(Y,imp(F1,F2)))
    ).
%    findall(Sym2,(synonym(Sym,Sym2), \+ Sym2 = Sym),
