/*************************************************************************

    File: holeSemantics.pl
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

:- module(holeSemantics,[info/0,
                         prefix/0,
                         infix/0,
                         holeSemantics/0,
			 holeSemantics/2,
			 holeSemanticsTestSuite/0]).

:- use_module(readLine,[readLine/1]).

:- use_module(comsemPredicates,[infix/0,
                                prefix/0,
                                printRepresentations/1]).

:- use_module(sentenceTestSuite,[sentence/2]).

:- use_module(pluggingAlgorithm,[plugUSR/2]).

:- use_module(betaConversion,[betaConvert/2]).

:- [englishGrammar].

:- [englishLexicon].

:- [semLexHole].

:- [semRulesHole].

/* Used for Wordnet */
:- consult('../wordnet/wn_s.pl').
:- use_module(readLine,[checkWords/2]).
/* end */

/*========================================================================
   Driver Predicates
========================================================================*/

/* Predicates for Curt */

holeSemantics:-
   readLine(Sentence),
   wordnetLexicon(Sentence,_),
   setof(USR,t([sem:USR],Sentence,[]),USRs),
   findall(Sem,(member(USR,USRs), plugUSR(USR,Sem)),Sems1),
   %filterAlphabeticVariants(Sems1,Sems2),
   printRepresentations(Sems1).

holeSemantics(Sentence,Sems1):-
   wordnetLexicon(Sentence,_),   
   setof(USR,t([sem:USR],Sentence,[]),USRs),
   findall(Sem,(member(USR,USRs), plugUSR(USR,Sem)),Sems1).
   %filterAlphabeticVariants(Sems1,Sems2).

/* */


/* Original predicates to holeSemantics

holeSemantics:-
   readLine(Sentence),
   wordnetLexicon(Sentence,_),
   t([sem:USR],Sentence,[]),   
   printRepresentations([USR]),
   setof(Sem,plugUSR(USR,Sem),Sems),
   printRepresentations(Sems).

holeSemantics(Sentence,Sems):-
   wordnetLexicon(Sentence,_),
   t([sem:USR],Sentence,[]),   
   setof(Sem,plugUSR(USR,Sem),Sems).

*/

/* Predicates added in order to use wordnet words */

wordnetLexicon(L,SymList) :-
    findall(Sym,findWordnetLex(L,Sym),SymList), !.

findWordnetLex(L,Sym) :-
    s(Synset,_,Expression,Class,_,_),
    (
        (Class = n,
        member(Expression,L),
        atom_concat(Expression,Synset,Sym),
        Syn = Expression,        
        assert(lexEntry(noun,[symbol:Sym,syntax:[Syn]])) )
    ;
        (Class = v,
        member(Expression2,L),
        (Expression = Expression2; atom_concat(Expression,s,Expression2)),
        atom_concat(Expression,Synset,Sym),
        Syn = Expression,
        atom_concat(Syn,s,Syn2),
        assert(lexEntry(tv,[symbol:Sym,syntax:[Syn],inf:inf,num:sg])),
        assert(lexEntry(tv,[symbol:Sym,syntax:[Syn2],inf:fin,num:sg])),
        assert(lexEntry(tv,[symbol:Sym,syntax:[Syn],inf:fin,num:pl])),
        assert(lexEntry(iv,[symbol:Sym,syntax:[Syn],inf:inf,num:sg])),
        assert(lexEntry(iv,[symbol:Sym,syntax:[Syn2],inf:fin,num:sg])),
        assert(lexEntry(iv,[symbol:Sym,syntax:[Syn],inf:fin,num:pl])),
        assert(lexEntry(dv,[symbol:Sym,syntax:[Syn],inf:inf,num:sg])),
        assert(lexEntry(dv,[symbol:Sym,syntax:[Syn2],inf:fin,num:sg])),
        assert(lexEntry(dv,[symbol:Sym,syntax:[Syn],inf:fin,num:pl])))
    ;
        (Class = a,
        member(Expression,L),
        atom_concat(Expression,Synset,Sym),
        Syn = Expression,
        assert(lexEntry(adj,[symbol:Sym,syntax:[Syn]]))
        )
    ).

/* end */

/*========================================================================
   Testsuite Predicates
========================================================================*/

holeSemanticsTestSuite:-
   nl, write('>>>>> HOLE SEMANTICS ON SENTENCE TEST SUITE <<<<< '), nl,
   sentence(Sentence,Readings),
   format('~nSentence: ~p (~p readings)',[Sentence,Readings]),
   holeSemantics(Sentence,Sems),
   printRepresentations(Sems),
   fail.

holeSemanticsTestSuite.


/*========================================================================
   Info
========================================================================*/

info:-
   format('~n> ------------------------------------------------------------------- <',[]),
   format('~n> holeSemantics.pl, by Patrick Blackburn and Johan Bos                <',[]),
   format('~n>                                                                     <',[]),
   format('~n> ?- holeSemantics.            - parse a typed-in sentence            <',[]),
   format('~n> ?- holeSemantics(S,F).       - parse a sentence and return formulas <',[]),
   format('~n> ?- holeSemanticsTestSuite.   - run the test suite                   <',[]),
   format('~n> ?- infix.                    - switches to infix display mode       <',[]),
   format('~n> ?- prefix.                   - switches to prefix display mode      <',[]),
   format('~n> ?- info.                     - show this information                <',[]),
   format('~n> ------------------------------------------------------------------- <',[]),
   format('~n~n',[]).


/*========================================================================
   Display info at start
========================================================================*/

:- info.
