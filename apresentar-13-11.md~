**Capítulo 1**

- Vocabulários - símbolos e _arity_

Exemplo:
{(love,2),
(customer,1),
(robber,1),
(mia,0),
(vincent,0),
(honey-bunny,0),
(yolanda,0) }.

- Modelos - Domínio (D) e função de interpretação (F) - M = (D, F)

Exemplo:
D = {d1,d2,d3,d4}
F(mia) = d1
F(honey-bunny) = d2
F(vincent) = d3
F(yolanda) = d4
F(customer) = {d1,d3}
F(robber) = {d2,d4}
F(love) = {(d4,d2),(d3,d1)}.

- Linguagens de Primeira Ordem

Given some vocabulary, we build the first-order language over that 
vocabulary out of the following ingredients:
1. All the symbols in the vocabulary. We call these symbols the
non-logical symbols of the language.
2. A countably infinite collection of variables x, y, z, w, ..., and so
on.
3. The boolean connectives ¬ (negation), ∧ (conjunction), ∨ (disjunction), and —► (implication).
4. The quantifiers ∀ (the universal quantifier) and ∃ (the existential
quantifier).
5. The round brackets ) and ( and the comma. (These are essentially
punctuation marks; they are used to group symbols.)

Atomic formulas:
If R is a relation symbol of arity n, and t\ ,..., tn are terms, then
R(t1, • • •, tn) is an atomic (or basic) formula.

Well formed formulas (or wffs, or simply formulas) 
1. All atomic formulas are wffs.
2. If φ and ψ are wffs then so are ¬φ, (φ∧ψ), (φ∨ψ), and (φ —► ψ).
3. If φ is a wff, and x is a variable, then both ∃xφ and ∀xφ are wffs.
(We call φ the matrix of such wffs.)
4. Nothing else is a wff.

Bound/Free:
1. Any occurrence of any variable is free in any atomic formula.
2. If an occurrence of any variable is free in (f> or in ^, then that
same occurrence is free in -■(/>, (0 A ^), (0 V ^), and (0 —► ip).
3. If an occurrence of a variable x is free in 0, then that occurrence is
free in Vy0 and 3y0 (for any variable y distinct from x). However,
no occurrence of x is free in Vx0 and 3x0.
4. The only free variables in a formula (f> are those whose freeness
follows from the preceding clauses. Any variable in a formula that
is not free is said to be bound.

- Satisfaction
- Function symbols, equality, sorted-first order
- Tarefas de Inferência:
-- The Querying Task: Given a model M and a first-order formula φ,
is φ satisfied in M or not?
-- The Consistency Checking Task: Given a first-order formula φ, is φ
consistent (that is: satisfiable) or inconsistent (that is: unsatisfiable)?
-- The Informativity Checking Task: Given a first-order formula φ,
is φ informative (that is: invalid) or uninformative (that is: valid)?

- Modelos em código prolog
- Representando fórmulas
- satisfaction - modelChecker1
- Problemas (apenas o 1 acontece comigo!)

- Capacidades de inferência da FOL - modelar background knowledge
Outras lógicas (modal, híbrida, description): computáveis mas menos expressivas. Segundo o autor, provavelmente melhor pra tarefas mais específicas.
- Capacidades de representação - exemplo da passagem do tempo
Também necessidade, crença, eventos...
Lógica segunda ordem simulada por lógica de primeira ordem.

**Capítulo 2**

- Composicionalidade: the claim that the words making up a sentence contribute all the bits and pieces needed to build the sentence's semantic representation.
Semântica composicional pela estrutura sintática.

- Experimento 1
Funciona:
? - s(Sem, [mia,snorts] ,[]).

Dá a resposta certa, bem como uma resposta errada: (interação indesejada das regras!)
? - s(Sem,[a, woman, snorts], []).

- Experimento 2 - Idéia: Não usar variáveis anônimas
Três argumentos extra: bound variable, contribuição do substativo (restriction), contribuição do sintagma verbal (nuclear scope)
Como funcionam: Interação de np(SemPN,Sem,Sem)—> pn(SemPN) com s(Sem)—> np(X,SemVP,Sem), vp(X,SemVP).

- Lambda calculus - abstrações e aplicações. Conversões beta e alpha (renomear variáveis bound - é necessário).

- Abordagem:
1. Specify a DCG for the fragment of natural language of interest.
2. Specify semantic representations for the lexical items with the help of the lambda calculus.
3. Specify the semantic representation R' of a syntactic item R whose parts are F and A with the help of functional application.

That is, specify which of the subparts is to be thought of as functor (here it's F), which as argument (here it's A) and then define R' to be F'@A', where F' is the semantic representation of F and A' is the semantic representation of A.
