:- use_module(comsemPredicates,[infix/0,prefix/0]).

s(Sem)--> np(SemNP), vp(Sem), 
   {
    arg(1,Sem,SemNP)
   }.

s(Sem)--> np(Sem), vp(SemVP), 
   {
    arg(1,SemVP,X),
    arg(1,Sem,X),
    arg(2,Sem,Matrix),
    arg(2,Matrix,SemVP)
   }.

np(Sem)--> pn(Sem).

np(Sem)--> det(Sem), noun(SemNoun), 
   {
    arg(1,SemNoun,X),
    arg(1,Sem,X),
    arg(2,Sem,Matrix),
    arg(1,Matrix,SemNoun)
   }.

vp(Sem)--> iv(Sem).


/*========================================================================
   Proper Names
========================================================================*/

pn(vincent)--> [vincent].
pn(mia)--> [mia].


/*========================================================================
   Transitive Verbs
========================================================================*/

tv(love(_,_))--> [loves].
tv(like(_,_))--> [likes].


/*========================================================================
   Intransitive Verbs
========================================================================*/

iv(snort(_))--> [snorts].
iv(walk(_))--> [walks].


/*========================================================================
   Determiners
========================================================================*/

det(some(_,and(_,_)))--> [a].
det(all(_,imp(_,_)))--> [every].


/*========================================================================
   Nouns
========================================================================*/

noun(woman(_))--> [woman].
noun(footmassage(_))--> [foot,massage].

