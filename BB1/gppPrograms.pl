% Arquivo de teste / usos 

:- use_module(cooperStorage,[info/0,
                         infix/0,
                         prefix/0,             
                         cooperStorage/0,
			 cooperStorage/2,
			 cooperStorageTestSuite/0,
			 filterAlphabeticVariants/2]).
			 
/*:- use_module(readLine,[readLine/1]).

:- use_module(comsemPredicates,[memberList/2,
				appendLists/3,
				selectFromList/3,
				compose/3,
                                infix/0,
                                prefix/0,
				printRepresentations/1]).

:- use_module(alphaConversion,[alphabeticVariants/2]).*/

:- use_module(betaConversion,[betaConvertList/2]).

			 
interp:-
   A1 = [okay(A),bo(lam(B,some(C,and(and(piercing(C),some(D,and(needle(D),doneWith(C,D)))),app(B,C)))),A)],
   A2 = [okay(A),bo(lam(B,some(C,and(and(piercing(C),doneWith(C,D)),app(B,C)))),A),bo(lam(E,some(F,and(needle(F),app(E,F)))),D)],
   A3 = [some(A,and(and(piercing(A),some(B,and(needle(B),doneWith(A,B)))),okay(A)))],
   A4 = [some(A,and(and(piercing(A),doneWith(A,B)),okay(A))),bo(lam(C,some(D,and(needle(D),app(C,D)))),B)],
   Arg = A2,
   write(Arg),
   setof(Ans,cooperStorage:sRetrieval(Arg,Ans),Sems1),
   betaConvertList(Sems1,Sems3),
   %filterAlphabeticVariants(Sems3,Sems2),
   printRepresentations(Sems3).
   
pred :-
   X = okay(A),
   Y = bo(lam(B,some(C,and(and(piercing(C),doneWith(C,D)),app(B,C)))),A),
   Z = bo(lam(E,some(F,and(needle(F),app(E,F)))),D),
   Y = bo(Y1,A),
   Z = bo(Z1,D),
   write("piercing then needle"), nl,
   betaConvert(app(Z1,lam(D,app(Y1,lam(A,X)))),Ans1),
   printRepresentations([Ans1]), nl,
   write("needle then piercing"), nl,
   betaConvert(app(Y1,lam(A,app(Z1,lam(D,X)))),Ans2),
   printRepresentations([Ans2]).
   
pred2 :-
   X = okay(A),
   Y = bo(lam(B,some(C,and(and(piercing(C),doneWith(C,D)),app(B,C)))),A),
   Z = bo(lam(E,some(F,and(needle(F),app(E,F)))),D),
   Y = bo(Y1,A),
   Z = bo(Z1,D),
   betaConvert(app(Z1,lam(D,X)),Ans1),
   betaConvert(app(Y1,lam(A,app(Z1,lam(D,X)))),Ans2),
   printRepresentations([Ans1]),nl,
   printRepresentations([app(Y1,lam(A,Ans1))]),nl,
   printRepresentations([Ans2]).