/*************************************************************************

    File: kellerStorage.pl
    Copyright (C) 2004,2005,2006 Patrick Blackburn & Johan Bos

    This file is part of BB1, version 1.3 (November 2006).

    BB1 is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    BB1 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with BB1; if not, write to the Free Software Foundation, Inc., 
    59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*************************************************************************/

:- module(negationKellerStorage,[infix/0,
                         prefix/0,
                         info/0,
                         negationKellerStorage/0,
			 negationKellerStorage/2,
			 negationKellerStorageTestSuite/0]).

:- use_module(readLine,[readLine/1]).

:- use_module(comsemPredicates,[memberList/2,
				appendLists/3,
				selectFromList/3,
				compose/3,
                                infix/0,
                                prefix/0,
				printRepresentations/1]).

:- use_module(alphaConversion,[alphabeticVariants/2]).

:- use_module(betaConversion,[betaConvert/2]).

:- [englishGrammar].

:- [englishLexicon].

:- use_module(sentenceTestSuite,[sentence/2]).

:- [negationSemLexStorage].

:- [negationSemRulesKeller].


/*========================================================================
   Driver Predicates
========================================================================*/

negationKellerStorage:-
   readLine(Sentence),
   setof(Sem,t([sem:Sem],Sentence,[]),Sems1),
   filterAlphabeticVariants(Sems1,Sems2),
   printRepresentations(Sems2).

negationKellerStorage(Sentence,Sems2):-
   setof(Sem,t([sem:Sem],Sentence,[]),Sems1),
   filterAlphabeticVariants(Sems1,Sems2).


/*========================================================================
   Test Suite Predicates
========================================================================*/

negationKellerStorageTestSuite:-
   nl, write('>>>>> KELLER + NEGATION STORAGE ON SENTENCE TEST SUITE <<<<< '), nl,
   sentence(Sentence,Readings),
   format('~nSentence: ~p (~p readings)',[Sentence,Readings]),
   negationKellerStorage(Sentence,Sems),
   printRepresentations(Sems),
   fail.

kellerStorageTestSuite.


/*========================================================================
   Filter Alphabetic Variants
========================================================================*/

filterAlphabeticVariants(L1,L2):-
   selectFromList(X,L1,L3),
   memberList(Y,L3),
   alphabeticVariants(X,Y), !,
   filterAlphabeticVariants(L3,L2).

filterAlphabeticVariants(L,L).


/*========================================================================
   Quantifier Retrieval
========================================================================*/

sRetrieval([S],S).

/* sRetrieval([Sem|Store],S):-
   selectFromList(bo([Q|NestedStore],X),Store,TempStore),
   appendLists(NestedStore,TempStore,NewStore),
   sRetrieval([app(Q,lam(X,Sem))|NewStore],S). */
   
sRetrieval([Sem|Store],S):-
   selectFromList(bo([Q|NestedStore],X),Store,TempStore),
   \+ X == av,
   appendLists(NestedStore,TempStore,NewStore),
   sRetrieval([app(Q,lam(X,Sem))|NewStore],S).   

sRetrieval([Sem|Store],S):-
   selectFromList(bo([Q|NestedStore],X),Store,TempStore),
   X == av, %nl, write(Store), nl, 
   appendLists(NestedStore,TempStore,NewStore),
   sRetrieval([app(Q,Sem)|NewStore],S).      

/*========================================================================
   Info
========================================================================*/

info:-
   format('~n> --------------------------------------------------------------------- <',[]),
   format('~n> negationKellerStorage.pl, by Guilherme Passos,           original     <',[]),
   format('~n> kellerStorage.pl by Patrick Blackburn and Johan Bos,                  <',[]),
   format('~n>                                                                       <',[]),
   format('~n> ?- negationKellerStorage.            - parse a typed-in sentence      <',[]),
   format('~n> ?- negationKellerStorage(S,F). - parse a sentence and return formulas <',[]),
   format('~n> ?- negationKellerStorageTestSuite.   - run the test suite             <',[]),
   format('~n> ?- infix.                    - switches to infix display mode         <',[]),
   format('~n> ?- prefix.                   - switches to prefix display mode        <',[]),
   format('~n> ?- info.                     - show this information                  <',[]),
   format('~n> --------------------------------------------------------------------- <',[]),
   format('~n~n',[]).


/*========================================================================
   Display info at start
========================================================================*/

:- info.
