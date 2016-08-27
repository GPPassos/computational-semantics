/*************************************************************************

    File: semLexHole.pl
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

/*========================================================================
   Semantic Macros
========================================================================*/

semLex(det,M):-
   M = [type:uni,
        sem:lam(N,lam(V,lam(H,lam(L,some(H1,some(L1,some(L2,some(L3,some(X,
                and(hole(H1),and(label(L1),and(label(L2),and(label(L3),
                    and(all(L2,X,L3),and(imp(L3,L1,H1),and(leq(L,H1),
                        and(leq(L2,H),and(app(app(app(N,X),H),L1),
                            app(app(app(V,X),H),L)))))))))))))))))))].

semLex(det,M):-
   M = [type:indef,
        sem:lam(N,lam(V,lam(H,lam(L,some(H1,some(L1,some(L2,some(L3,some(X,
                and(hole(H1),and(label(L1),and(label(L2),and(label(L3),
                    and(some(L2,X,L3),and(and(L3,L1,H1),and(leq(L,H1),
                        and(leq(L2,H),and(app(app(app(N,X),H),L1),
                            app(app(app(V,X),H),L)))))))))))))))))))].

semLex(det,M):-
   M = [type:wh,
        sem:lam(N,lam(V,lam(H,lam(L,some(H1,some(L1,some(L2,some(X,and(hole(H1),
                and(label(L1),and(label(L2),and(que(L2,X,L1,H1),and(leq(L,H1),
                    and(leq(L2,H),and(app(app(app(N,X),H),L1),
                        app(app(app(V,X),H),L))))))))))))))))].
% Exercise 6.1.3 -- Start
semLex(det,M):-
   M = [type:neg,
        sem:lam(N,lam(V,lam(H,lam(L,some(H1,some(L1,some(L2,some(L3,some(L4,
            and(hole(H1),and(label(L1),and(label(L2),and(label(L3),and(label(L4),
            and(not(L1,L2),and(some(L2,X,L3),and(and(L3,L4,H1),
            and(leq(L1,H),and(leq(L,H1),and(app(app(app(N,X),H),L4),app(app(app(V,X),H),L)))))))))))))))))))))].

semLex(det,M):-
   M = [type:def,
        sem:lam(N,lam(V,lam(H,lam(L,some(H1,some(L1,some(L2,some(L3,some(L4,some(L5,some(L6,some(L7,some(L8,
             and(hole(H1),and(label(L1),and(label(L2),and(label(L3),and(label(L4),and(label(L5),and(label(L6),and(label(L7),and(label(L8),
             and(some(L1,X,L2),and(and(L2,L3,L4),and(and(L3,L5,H1),and(all(L4,Y,L6),and(imp(L6,L7,L8),and(eq(L8,Y,X),
             and(leq(L1,H),and(leq(L,H1),and(app(app(app(N,X),H),L5),and(app(app(app(V,X),H),L),app(app(app(N,Y),H),L7)))))))))))))))))))))))))))))))))].

% Exercise 6.1.3 -- End

semLex(pn,M):-
   M = [symbol:Sym,
        sem:lam(V,lam(H,lam(L,app(app(app(V,Sym),H),L))))].

semLex(noun,M):-
   M = [symbol:Sym,
        sem:lam(X,lam(H,lam(L,and(pred1(L,Sym,X),leq(L,H)))))].

semLex(iv,M):-
   M = [symbol:Sym,
        sem:lam(X,lam(H,lam(L,and(pred1(L,Sym,X),leq(L,H)))))].

semLex(tv,M):-
   M = [symbol:Sym,
        sem:lam(Z,lam(X,app(Z,lam(Y,lam(H,lam(L,and(pred2(L,Sym,X,Y),leq(L,H))))))))]. 

% Exercise 6.1.3 -- Start

semLex(dv,M):-
   M = [symbol:Sym,
        sem:lam(P,lam(Q,lam(X,app(Q,lam(Y,app(P,lam(Z,lam(H,lam(L,and(pred3(L,Sym,X,Y,Z),leq(L,H)))))))))))].

% Exercise 6.1.3 -- End

semLex(qnp,M):-
   M = [type:wh,
        symbol:Sym,
        sem:lam(V,lam(H,lam(L,some(H1,some(L2,some(L3,some(X,and(hole(H1),and(label(L2),
                and(label(L3),and(que(L2,X,L3,H1),and(pred1(L3,Sym,X),and(leq(L,H1),
                    and(leq(L2,H),app(app(app(V,X),H),L)))))))))))))))]. 

% Exercise 6.1.3 -- Start

semLex(qnp,M):-
   M = [type:uni,
        symbol:Sym,
        sem:lam(P,lam(H,lam(L,some(L1,some(L2,some(L3,some(H1,and(label(L1),and(label(L2),and(label(L3),and(hole(H1),and(
            all(L1,X,L2),and(imp(L2,L3,H1),and(pred1(L3,Sym,X),and(
            leq(L1,H),and(leq(L,H1),
            app(app(app(P,X),H),L)))))))))))))))))].

semLex(qnp,M):-
   M = [type:neg,
        symbol:Sym,
        sem:lam(P,lam(H,lam(L,some(L1,some(L2,some(L3,some(L4,some(H1,and(label(L1),and(label(L2),and(label(L3),and(label(L4),and(hole(H1),and(
            not(L1,L2),and(some(L2,X,L3),and(imp(L3,L4,H1),and(pred1(L4,Sym,X),and(
            leq(L1,H),and(leq(L,H1),
            app(app(app(P,X),H),L))))))))))))))))))))].

% Exercise 6.1.3 -- End

semLex(cop,M):-
    M = [pol:pos,
         sem:lam(Z,lam(X,app(Z,lam(Y,lam(H,lam(L,and(eq(L,Y,X),leq(L,H))))))))];
    M = [pol:neg,
         sem:lam(Z,lam(X,app(Z,lam(Y,lam(H,lam(L,some(L1,and(label(L1),some(H1,and(hole(H1),and(not(L1,H1),
                 and(eq(L,Y,X),and(leq(L,H1),leq(L1,H))))))))))))))].

/*semLex(relpro,M):-
   M = [sem:lam(V,lam(N,lam(X,lam(H,lam(L,some(H1,some(L1,some(L2,and(hole(H1),and(label(L1),
                and(label(L2),and(and(L,L1,H1),and(leq(L,H),and(leq(L2,H1),
                    and(app(app(app(V,X),H),L2),app(app(app(N,X),H),L1))))))))))))))))].
					
					Modified for exercise 3.4.3*/
					
semLex(relpro,M):-
   M = [sem:lam(V,lam(N,lam(X,lam(H,lam(L,some(H1,some(L1,some(L2,and(hole(H1),and(label(L1),
                and(label(L2),and(and(L,L1,H1),and(leq(L,H),and(leq(L2,H1),
                    and(app(app(app(V,X),H1),L2),app(app(app(N,X),H),L1))))))))))))))))].

semLex(prep,M):-
   M = [symbol:Sym,
        sem:lam(Z,lam(N,lam(X,lam(H,lam(L,some(H2,some(L2,some(L3,and(hole(H2),and(label(L2),
                and(label(L3),and(and(L,L2,H2),and(leq(L,H),and(leq(L3,H2),and(app(app(app(Z,
                    lam(Y,lam(H1,lam(L1,and(pred2(L1,Sym,Y,X),leq(L1,H1)))))),H),L3),
                        app(app(app(N,X),H),L2))))))))))))))))].

semLex(adj,M):-
   M = [symbol:Sym,
        sem:lam(P,lam(X,lam(H,lam(L,some(L1,some(L2,and(label(L1),and(label(L2),and(and(L,L1,L2),
                and(pred1(L2,Sym,X),and(leq(L,H),app(app(app(P,X),H),L1))))))))))))].

semLex(av,M):-
   M = [pol:neg,
        sem:lam(V,lam(X,lam(H,lam(L,some(S,some(N,and(hole(S),and(label(N),and(not(N,S),
                and(leq(N,H),and(leq(L,S),app(app(app(V,X),H),L))))))))))))];
   M = [pol:pos,
        sem:lam(V,lam(X,lam(H,lam(L,app(app(app(V,X),H),L)))))]. 

semLex(coord,M):-
   M = [type:conj,
        sem:lam(C1,lam(C2,lam(X,lam(H,lam(L,some(L1,some(L2,and(label(L1),and(label(L2),
                and(and(L,L1,L2),and(leq(L,H),and(app(app(app(C1,X),H),L1),
                    app(app(app(C2,X),H),L2)))))))))))))];  
   M = [type:disj,
        sem:lam(C1,lam(C2,lam(X,lam(H,lam(L,some(L1,some(L2,and(label(L1),and(label(L2),
                and(or(L,L1,L2),and(leq(L,H),and(app(app(app(C1,X),H),L1),
                    app(app(app(C2,X),H),L2)))))))))))))].

