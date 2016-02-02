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
	
###Exercises###

####3.3.1####
A mesma fórmula é repetida mais de uma vez, previsivelmente. Isso ocorre pois há estratégias diferentes nos pontos de bifurcação os quais podem levar para mesmas fórmulas.

####3.3.2####
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

####3.3.4####
There are 5 readings for this sentence. Cooper storage assigns 3 readings for this sentence. If storage is not optional, then only 2.

The readings that are missing are `some(A,and(woman(A),not(all(B,imp(boxer(B),love(B,A))))))` and `not(all(A,imp(boxer(A),some(B,and(woman(B),love(A,B))))))`.

I've modified Keller Storage files in order to include negation in stores: consult `negationKellerStorage.pl`, `negationSemLexStorage.pl` and `negationSemRulesKeller.pl`.


###Notes###

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

- (p. 137) 
> More generally, we don't want to generate any plugging where two nodes with the same parent dominate a common node.

I'm not sure what this means. At the example, *l2* and *h1* dominate *l3*, but they don't share a parent: actually, *l2* is the parent of *h1*.

What about example on pages 140 and 141, where `l1 <= h`, `l2 <= h` and l1 is 'inside' l2?

### Notes ###

- The notation `>=` suggests an (partial) order. This is a bit unfortunate, as the edges of the tree representation don't correspond to the `>=` relation (for example, because `>=` is possible only between a label and a hole, not between labels). Besides, every (partial) order corresponds to a DAG (just as every DAG corresponds to a (partial) order), however not every DAG corresponds to a tree.