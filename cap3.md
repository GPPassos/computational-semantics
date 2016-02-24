## Cooper Storage ##

- *Every costumer in a restaurante smokes*
	- Gerando uma interpretação errada! (com um variável livre) Pelo exemplo, *A robber likes every customer in a restaurant*, isso parece ser culpa do *in*.
	- Além disso, bem como em alguns casos abaixo, há uma interpretação na qual a frase é verdadeira se não existirem restaurantes, enquanto há outra na qual a frase é falsa se não existirem restaurantes. Entretanto, esse parece um caso mais difícil de se escolher qual a correta (então as 2 leituras talvez sejam aceitáveis)

- As frases abaixo possuem algo curioso. Elas possuem um existencial que pode ficar interno ou externo na interpretação, mas isso não parece correto.
	- *Mia or Vincent eats a quarter pound with cheese* (2 leituras)
		- Apesar de estar como duas leituras, elas são logicamente equivalentes.
	- *Every woman or a man dances* (2 leituras)
		- A leitura com o "ou" mais externo é equivalente à com o "every" outscoping. Até aí, ok. Entretanto, a leitura com o "exists" outscoping tem interpretação de que a frase é falsa se não existirem homens (ainda que todas as mulheres dancem)! Isso parece errado.
	- *Mia or a man dances*
		- Idem ao problema acima. Entretanto, nesse caso está no código que há apenas uma leituras, quando as duas interpretações não são logicamente equivalentes (se nenhum homem existir...)

### Exercises ###

#### 3.3.1 ####
A mesma fórmula é repetida mais de uma vez, previsivelmente. Isso ocorre pois há estratégias diferentes nos pontos de bifurcação os quais podem levar para mesmas fórmulas.

#### 3.3.2 ####
Added to englishLexicon.pl:
`lexEntry(iv,[symbol:okay,syntax:[is,okay], inf:fin,num:sg]).`
`lexEntry(iv,[symbol:okay,syntax:[are,okay], inf:fin,num:pl]).`
`lexEntry(tv,[symbol:doneWith,syntax:[is,done,with],inf:fin,num:sg]).`

As interpretações são:
`1 all(A,imp(and(some(B,and(needle(B),doneWith(A,B))),piercing(A)),okay(A)))`
`2 all(A,imp(and(doneWith(A,B),piercing(A)),some(C,and(needle(C),okay(A)))))`
`3 some(A,and(needle(A),all(B,imp(and(doneWith(B,A),piercing(B)),okay(B)))))`

1 and 3 are correct. However, 2 has the same problem than the one in `Every costumer in a restaurante smokes`: it has a free variable, `B`!

I've discovered that this problem happens when both NPs are stored and when *needle* is retrieved before *piercing* is.

Conclusion: This is a problem of nested NP, which is solved by Keller Storage. In this case, this issue happens when internal NP is retrieved before the external NP.

#### 3.3.4 ####
There are 6 readings for this sentence. Cooper storage assigns 3 readings for this sentence. If storage is not optional, then only 2.

The readings that are missing are `some(A,and(woman(A),not(all(B,imp(boxer(B),love(B,A))))))` and `not(all(A,imp(boxer(A),some(B,and(woman(B),love(A,B))))))`.

I've modified Keller Storage files in order to include negation in stores: consult `negationKellerStorage.pl`, `negationSemLexStorage.pl` and `negationSemRulesKeller.pl`. This one can find all 6 readings. It is, though, ad hoc in a sense.


### Notes ###

- Scope ambiguities sometimes seem not to happen in natural language. In `Every worker has a mother`, it seems clear which is the correct interpretation. In `Every man loves a woman`, it's a bit less clear but I suppose people would mostly answer that the universal outscope is correct. However, in `Every student did not pass an exam.`, it seems more natural to favor the existential outscope

- Just noticed that, in englishGrammar.pl, `n(...)` is different from `noun(...)`. This is a bit confunsing, as `n(...)` stands for *noun* as well. It's as if there's a word class *noun lato sensu* a different one *noun stricto sensu*.

- In semLexStorage.pl, I changed

`semLex(relpro,M):-`
`M = [sem:[lam(P,lam(Q,lam(X,and(app(P,X),app(Q,X)))))]].`
to
`semLex(relpro,M):-`
`M = [sem:[lam(P,lam(Q,lam(X,and(app(Q,X),app(P,X)))))]].`
for a more natural reading. I did the same with the undefined determiner and prepositions.

## Keller Storage ##

> And now there is almost nothing to do. First, we don't need to alter the semantic macros at all; we can continue to use the file semLexStorage.pl unchanged. Second, only two of the semantic rules need to be changed, namely those that deal with noun phrases:
>
> `combine(np:[app(A,B)|S],[det:[A],n:[B|S]]).`
> `combine(np:[lam(P,app(P,X)),bo([app(A,B)|S],X)],[det:[A],n:[B|S]]).`

However, `combine(np:[app(A,B)|S],[det:[A],n:[B|S]]).` didn't change at all. There's an identical clause in semRulesCooper.pl.

### Exercises ###

#### 3.3.7 ####
Small fix: Although it's written `five-dollar shake`, it should be `five dollar shake`.

I'm not sure I've understood this question. If every quantifier is put at a Cooper Storage, then it makes sense: there should be at least 3! readings (depending on the order at which it binding operator is retrieved). However, this is not so at Keller Storages, as `a five dollar shake` is a NP inside another, so it should have at least 3 readings, which is true. However, this does not make a reading "excluded"...

## Keller Storage with Negation ##

see exercise 3.3.4.

## Hole Semantics##

### Questions ###

- (p. 137)
> More generally, we don't want to generate any plugging where two nodes with the same parent dominate a common node.

Does this make sense for this example? At the example, *l2* and *h1* dominate *l3*, but they don't share a parent: actually, *l2* is the parent of *h1*.
In fact, even the code won't prohibit this kind of plugging!

I've seen where this makes sense (see original USR for `A woman that knows every boxer`).


:- parent(l2,h1).
:- parent(l2,l3).
:- admissiblePlugging([plug(h1,l3)]).

If it's sufficient and necessary to build a tree, perhaps what should be done is to affirm that every node which has a parent has only one parent. We can do this counting how many parents each node has (and it should be less or equal than one), but it's not very elegant.

- What about example on pages 140 and 141, where `l1 <= h`, `l2 <= h` and l1 is 'inside' l2? -- [ANSWER]: dominance relation! It is transitive!

- (p. 142) In proper noun, why there is no `leq(L,H)`?

- Is it necessary to add `\+ memberList(parent(X,Y),L)` to the second clause (and the analogue to the third clause) of `dom/3`?

### Exercises ###
#### Exercise 3.4.1. ####
There's a bijection between formulas and trees. It seems that there's a bijection between pluggins and trees.

#### Exercise 3.4.2 ####
This happens because in the first case, the search starts with a node that is in the cycle, which means that prolog searching won't make the same query twice. In the second case, prolog will first query for `dom(d,d)` and, using the second clause, will ask if `dom(a,d)`. Then, while in this query, eventually it'll query for `dom(c,d)`, matching `parent(c,Y)` with `parent(c,a)` and once again query for `dom(a,d)`. This will make every `dom(a,d)` query fall in a loop where once again the same query is made. Using an accumulator is sufficient to make it impossible that a query is made inside itself.

#### Exercise 3.4.3 ####

You just need to change the semantic of relative pronouns to
`semLex(relpro,M):-
   M = [sem:lam(V,lam(N,lam(X,lam(H,lam(L,some(H1,some(L1,some(L2,and(hole(H1),and(label(L1),
                and(label(L2),and(and(L,L1,H1),and(leq(L,H),and(leq(L2,H1),
                    and(app(app(app(V,X),H1),L2),app(app(app(N,X),H),L1))))))))))))))))].`

### Notes ###

- ~~The notation `>=` suggests an (partial) order. This is a bit unfortunate, as the edges of the tree representation don't correspond to the `>=` relation (for example, because `>=` is possible only between a label and a hole, not between labels). Besides, every (partial) order corresponds to a DAG (just as every DAG corresponds to a (partial) order), however not every DAG corresponds to a tree.~~
	- Nevermind, the dominance relation is a tree.

- (p. 142) Text is wrong: in `SemLex(tv,M)`, it should be `pred2(L,Sym,X,Y)` (code is correct)

- Hole semantics only gives a reading of `Butch kills a criminal or shoots Vincent` such that this sentence is false if there are no criminals. This seems to me counterintuitive.

- There's a mistake in `semLexHole.pl`, at `semLex(coord,M)`: the representations of `conj` and `disj` are the same. I fixed it by changing the one for `disj` to:
`   M = [type:disj, sem:lam(C1,lam(C2,lam(X,lam(H,lam(L,some(L1,some(L2,and(label(L1),and(label(L2), and(or(L,L1,L2),and(leq(L,H),and(app(app(app(C1,X),H),L1), app(app(app(C2,X),H),L2)))))))))))))].`
