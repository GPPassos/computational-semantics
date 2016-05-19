/*************************************************************************

    File: knowledgeableCurt.pl
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

:- module(curt,[curt/0,infix/0,prefix/0]).

:- use_module(callInference,[callTPandMB/6]).

:- use_module(readLine,[readLine/1]).

:- use_module(comsemPredicates,[infix/0,
                                prefix/0,
                                memberList/2,
				printRepresentations/1]).

:- use_module(kellerStorage,[kellerStorage/2]).

:- use_module(backgroundKnowledge,[backgroundKnowledge/2]).

:- use_module(elimEquivReadings,[elimEquivReadings/2]).

:- use_module(curtPredicates,[curtHelp/0,
                              curtOutput/1,
                              updateReadings/1,
                              updateModels/1,
                              updateHistory/1,
                              clearHistory/0,
                              selectReadings/3]).


/*========================================================================
   Dynamic Predicates
========================================================================*/

:- dynamic history/1, readings/1, models/1.

history([]).
readings([]).
models([]).


/*========================================================================
   Start Curt
========================================================================*/

curt:- 
   curtTalk(run).


/*========================================================================
   Control
========================================================================*/

curtTalk(quit).

curtTalk(run):-
   readLine(Input),
   curtUpdate(Input,CurtsMoves,State), 
   curtOutput(CurtsMoves),
   curtTalk(State).


/*========================================================================
   Update Curt's Information State
========================================================================*/

curtUpdate([],[clarify],run):- !.

curtUpdate([bye],[bye],quit):- !,
   updateReadings([]),
   updateModels([]),
   clearHistory.

curtUpdate([new],[],run):- !,
   updateReadings([]),
   updateModels([]),
   clearHistory.

curtUpdate([help],[],run):- !,
   curtHelp.

curtUpdate([infix],[],run):- !,
   infix.

curtUpdate([prefix],[],run):- !,
   prefix.

curtUpdate([select,X],[],run):-
   number(X),
   readings(R1),
   selectReadings(X,R1,R2), !,
   updateReadings(R2),
   models(M1),
   selectReadings(X,M1,M2),
   updateModels(M2).

curtUpdate([summary],[],run):-
   readings(Readings),
   elimEquivReadings(Readings,Unique),
   updateReadings(Unique),
   updateModels([]).

curtUpdate([knowledge],[],run):-
   readings(R), 
   findall(K,(memberList(F,R),backgroundKnowledge(F,K)),L),
   printRepresentations(L).
   
curtUpdate([readings],[],run):- !,
   readings(R),
   printRepresentations(R).

curtUpdate([models],[],run):- !,
   models(M),
   printRepresentations(M).

curtUpdate([history],[],run):- !,
   history(H),
   printRepresentations(H).

curtUpdate(Input,Moves,run):-
   kellerStorage(Input,Readings), !,
   updateHistory(Input),
   consistentReadings(Readings,[]-ConsReadings,[]-Models),
   (
      ConsReadings=[],
      combine(ConsReadings,CombinedReadings), % Botamos aqui para diferenciar quando não foi calculado o InfReadings
      Moves=[contradiction]
   ;
      \+ ConsReadings=[],
      informativeReadings(ConsReadings,[]-InfReadings),
      combine(InfReadings,CombinedReadings), %idem   
      (
         InfReadings=[],
         Moves=[obvious]
      ;  
         \+ InfReadings=[],% print(InfReadings),
         Moves=[accept]
      ),
      %combine(ConsReadings,CombinedReadings),  % Por que não usar InfReadings? 
      updateReadings(CombinedReadings),
      updateModels(Models)
   ).

curtUpdate(_,[noparse],run).


/*========================================================================
   Combine New Utterances with History
========================================================================*/

% Alterei código abaixo para lidar com a situação em que InfReadings = []

combine(New,New):-
   readings([]).

combine(Readings,Updated):-
   readings([Old|_]),
    (
        \+ Readings = [],
        findall(and(Old,New),memberList(New,Readings),Updated)
    ;
        Updated = [Old]
    ).


/*========================================================================
   Select Consistent Readings
========================================================================*/

consistentReadings([],C-C,M-M).

consistentReadings([New|Readings],C1-C2,M1-M2):-
   readings(Old),
   (
      consistent(Old,New,Model), !,
      consistentReadings(Readings,[New|C1]-C2,[Model|M1]-M2) 
   ;
      consistentReadings(Readings,C1-C2,M1-M2) 
   ).


/*========================================================================
   Consistency Checking calling Theorem Prover and Model Builder
========================================================================*/

consistent([Old|_],New,Model):-
   backgroundKnowledge(and(Old,New),BK),
   DomainSize=15,
   callTPandMB(not(and(and(BK,Old),New)),and(and(BK,Old),New),DomainSize,Proof,Model,Engine),
   format('~nMessage (consistency checking): ~p found a result.',[Engine]),
   \+ Proof=proof, Model=model([_|_],_).

consistent([],New,Model):-
   backgroundKnowledge(New,BK),
   DomainSize=15,
   callTPandMB(not(and(BK,New)),and(BK,New),DomainSize,Proof,Model,Engine),
   format('~nMessage (consistency checking): ~p found a result.',[Engine]),
   \+ Proof=proof, Model=model([_|_],_).


/*========================================================================
   Select Informative Readings
========================================================================*/

informativeReadings([],I-I).

informativeReadings([New|L],I1-I2):-
   readings(Old),
   (
      informative(Old,New), !,
      informativeReadings(L,[New|I1]-I2) 
   ;
      informativeReadings(L,I1-I2) 
   ).


/*========================================================================
   Informativity Checking calling Theorem Prover
========================================================================*/

informative([Old|_],New):-
   backgroundKnowledge(and(Old,New),BK),
   DomainSize=15,
   callTPandMB(not(and(and(BK,Old),not(New))),and(and(BK,Old),not(New)),DomainSize,Proof,Model,Engine),
   format('~nMessage (informativity checking): ~p found a result.',[Engine]),% format('\n New: ~p \t', [New]), print(Proof),
   \+ Proof=proof, Model=model([_|_],_).

informative([],New):-
   backgroundKnowledge(New,BK),
   DomainSize=15,
   callTPandMB(not(and(BK,not(New))),and(BK,not(New)),DomainSize,Proof,Model,Engine),
   format('~nMessage (informativity checking): ~p found a result.',[Engine]),
   \+ Proof=proof, Model=model([_|_],_).


/*========================================================================
   Info
========================================================================*/

info:-
   format('~n> ---------------------------------------------------------- <',[]),
   format('~n> knowledgableCurt.pl, by Patrick Blackburn and Johan Bos    <',[]),
   format('~n>                                                            <',[]),
   format('~n> ?- curt.                - start a dialogue with Curt       <',[]),
   format('~n>                                                            <',[]),
   format('~n> Type "help" to get more information about features         <',[]),
   format('~n> ---------------------------------------------------------- <',[]),
   format('~n~n',[]).



/*========================================================================
   Display info at start
========================================================================*/

:- info.

 
