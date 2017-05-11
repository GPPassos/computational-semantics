/**
  We are using:
  "um" depends on "cachorro"
  "cachorro" depends on "é"
  "é" depends on "Bidu"

  We decided that the head will be applied to children.
  (in which order? Notice we didn't decide that!  But this doesn't matter here)

  Bidu: "entity"
  um cachorro: "entity"

  cachorro: 
  um: determiner -- receives an entity, returns a "predicate"
  é: copula -- it's very natural to think of it 

  While "Bidu" could possibly be represented as the constant "bidu", how could we represent "um cachorro"?
  exists(X,cachorro(X)) would be a sentence, not a term!
  We would like to relate this "X" to properties, to talk about this "X" that is a dog.
  ("um cachorro" will have to be used as function, but "Bidu" as argument!
    This dual use of "entity" (as argument and as function) will make us use a transformation later)

  so we can think of it like this:
  predicate = (term -> wff)
  entity = (predicate -> wff)

  bidu: entity
  cachorro: predicate
  um: predicate -> entity

  Now we have left only "é"'s semantics.
  "um cachorro" is of type: 'type("um") applied to type("cachorro")'
  that is (predicate -> entity)(predicate)
  this can only be of type "entity"
  But "entity" is a function that receives a predicate and returns a wff, which would be too soon to make a wff!
  (that's the problem we talked about before)
  Perhaps we should transform "um cachorro" from entity to something else.

  So, let's say that "cachorro"'s relation (the dependency arc) to "é" is of (syntactical) type "predicate of copula".
  Of course, we want "é um cachorro" to have type "entity -> wff", as it'll receive "Bidu" and should end the sentence.
  Let's then give this semantics: Let X be a given type.
  predicate_of_copula: entity -> X -> (entity -> wff)
  Any type X should work, as long as "é" is of type X,
    as we would make ((predicate_of_copula)@("um cachorro")@("é")) of type (entity -> wff)

  Let's give to "é" a natural type: entity -> (entity -> wff)

  With typing and some basic semantics, this should write itself:
  As entities should receive a predicate and return a wff:
bidu -- lam(P,app(P,bidu)

  Predicates should receive a term and return a wff:
cachorro -- lam(X,cachorro(X))

  A determiner should transform a predicate into a term:
um -- lam(P,lam(Q,exists(X,and(app(P,X),app(Q,X)))))

  This "predicate of copula" transformation should have type:
    entity -> (entitiy -> entity -> wff) -> (entity -> wff)
  A very natural way of thinking this is: we receive a entity, then the copula, which is a function (receive one entity, returns function of "receive one entity, return wff"), and then simply apply this first entity to the copula!
pred_of_cop -- lam(E,lam(C,app(C,E)))

  Now we have to make the copula in a way which "works".
  First it should receive two entities. What we will do then is transform the first entity into a predicate, and then pass it the the second entity.
  So: lam(P,lam(Q,...
  Transform P into a predicate, using "é"'s meaning: We will do this calling some term "out of nothing" (abstracting), and using this term in a predicate to be passed to P. This will give a wff, except that it is abstracted to this "magical" term. So it's simplty a function: term -> wff, as we want it to be.
  ...lam(Y,app(P,lam(X,eq(X,Y))))...

  Getting it all together:
é -- lam(P,lam(Q,app(Q,lam(Y,app(P,lam(X,eq(X,Y)))))))

  And that's it!
**/

:- use_module(betaConversion,[info/0,
                          infix/0,
                          prefix/0, 
                          betaConvertTestSuite/0,
			  betaConvert/2]).

copula_transformation(In,Out) :- betaConvert(
				 app(
				     lam(E,lam(C,app(C,E))),
				     In),
				 Out).

bidu(Sem) :- Sem = lam(P,app(P,bidu)).
e(Sem) :- Sem = lam(P,lam(Q,app(Q,lam(Y,app(P,lam(X,eq(X,Y))))))).
um(Sem) :- Sem = lam(P,lam(Q,exists(X,and(app(P,X),app(Q,X))))).
cachorro(Sem) :- Sem = lam(X,cachorro(X)).

%% Query:
%% bidu(Bidu), e(E), um(Um), cachorro(Cach),
%% betaConvert(app(Um,Cach),UmCach),
%% copula_transformation(UmCach,UmCach_conv),
%% betaConvert(app(UmCach_conv,E),EUmCach),
%% betaConvert(app(EUmCach,Bidu),BiduEUmCach).
