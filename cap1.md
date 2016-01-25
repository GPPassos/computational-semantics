**Exercise 1.1.1**

{(vincent, 0), (marvin, 0), (jules, 0), (gun, 0), (back-of-the-seat, 0), (relaxed, 1), (driving,1), (tense, 1), (rests-at,2), (pointing,2)}

**Exercise 1.1.2**

Notação para representar em prolog: Lista de listas \[a,n\], onde "a" é átomo e "n" é número.
    Endereço do programa: ex1_1_2.pl
    Programa:

    is_vocabulary :- write("Insert vocabulary"), read(Lista), member(X, Lista), [A, N] = X, atom(A), number(N), member([A, M], Lista), N = M.

[ [relaxed, 1], [rests-at,2], [pointing,2], [driving,1], [tense, 1], [vincent, 0], [marvin, 0], [jules, 0], [gun, 0], [back-of-the-seat, 0]]

**Exercise 1.1.3**

D = {d1,d2,d3,d4,d5}

f(vincent) = d1
f(marvin) = d2
f(jules) = d3
f(gun) = d4
f(back-of-the-seat) = d5
f(relaxed) = {d1}
f(driving) = {d3}
f(tense) = {d2}
f(rests-at) = {(d4,d5)}
f(pointing) = {(d4,d2)}

**Exercise 1.3.4**

test(eq(mia,honey_bunny),2,[],undef). - Não funciona pois "mia" não está no vocabulário (no modelo) do exemplo 2
test(not(eq(mia,honey_bunny)),2,[],undef). - Idem
test(or(robber(X),customer(X)),2,[],undef). - Não é uma sentença, pois X é uma variável livre à qual não foi atribuída uma interpretação.
test(some(X,and(tasty(X),burger(X))),3,[],undef); test(not(some(X,and(tasty(X),burger(X)))),3,[],undef). - Termos que não estão no vocabulário/modelo.
test(some(X,and(woman(X),not(some(X,customer(X))))),2,[],undef). - Apesar de "woman" não estar no vocabulário, o verificador de modelo diz que esta sentença é falsa. Isso ocorre pois, apesar de "woman(X)" não poder ser processado, "not(some(X,customer(X)))" pode e é falsa (resultado "neg"), bastando isso para que o "and" retorne "neg". Esse não é o comportamento desejado.

**Exercise 1.3.5**

Essa mensagem de "Satisfied in model" mais de uma vez ocorre apenas em expressões que algum quantificador. Isso ocorre quando o verificador para expressões do tipo "some(X,Exp)" realiza um backtracking e nota que há mais de um elemento no modelo que satisfaz o procedimento. Como a verificação para expressões com o quantificador universal utiliza o verificador para o quant. existencial, isso ocorre com os dois tipos de quantificador.
Isso não parece ser algo útil, uma vez que só queremos saber se é satisfeito no modelo ou não. Acredito que bastaria realizar um cut no final do verificador existencial:

satisfy(some(X,Formula),model(D,F),G,pos):-
   memberList(V,D),
   satisfy(Formula,model(D,F),[g(X,V)|G],pos), !.

satisfy(some(X,Formula),model(D,F),G,neg):-
   setof(V,(memberList(V,D),satisfy(Formula,model(D,F),[g(X,V)|G],neg)),Dom),
   setof(V,memberList(V,D),Dom).

De fato, testando isso, dá certo. O modelCheckerTestSuite dá todos os resultados esperados sem que tenhamos uma repetição da mensagem.

**Exercise 1.3.6**

As variáveis não interagem, em resumo, pois em momento algum há unificação das mesmas. A função de interpretação "i" faz todo o trabalho necessário, dentro da avaliação de satisfação de expressões atômicas (predicados), para se saber se a expressão é verdadeira ou falsa, sem que diretamente se unifique a variável X. Desse modo, o uso repetido da variável não é relevante, uma vez que apenas se calcula o valor verdade (isso é, a satisfação no modelo) da expressão.
Isso fica claro ao se executar a avaliação de uma expressão com quantificador no modo de trace do prolog (ex.: evaluate(some(X,robber(X)),1).

**Exercise 1.3.9**

No caso "?- evaluate(X,1). ", o pattern matching é feito com a primeira regra, que é
"satisfy(some(X,Formula),model(D,F),G,pos):-
   memberList(V,D),
   satisfy(Formula,model(D,F),[g(X,V)|G],pos)."

Daí, o programa cai em loop aumentando infinitamente a lista G.

**Dúvidas**

*página 38* - \[**Solved!**\] Na definição de "i(X,model(_,F),G,Value)", por que é usado "X==Y" ao invés de "X=Y"? Dá na mesma? Resposta: "=" unifica as variáveis, "==" checa se são iguais sem realizar unificação. Como o símbolo da variável na função "g" (isto é, na lista "g") é importante, o que se deve fazer não é unificar X com Y, mas sim verificar se os símbolos são iguais.

*Exercise 1.3.4* - \[__Solved__\] Por que o seguinte código retorna "false"?

test(some(X,or(robber(X),customer(X))),2,[],Z).

_Resposta_: Porque "test" é um predicado definido no arquivo modelCheckerTestSuite.pl, de modo que ao fazer esse tipo de consulta, o prolog apenas tenta dar match com as afirmações já declaradas nesse arquivo. O teste que queremos fazerl, na realidade, é

evaluate(some(X,or(robber(X),customer(X))),2,[]).

o que funciona perfeitamente.

*Código do modelChecker1.pl* - Por que o cut na função i (interpretação)?
    Quando tentei retirar este cut para ver o que acontecia, o prolog simplesmente parou de identificar o procedimento. Acredito que ele seja importante para que apenas o primeiro resultado achado na interpretação de variáveis livres (G) seja utilizado, como para a avaliação de sentenças do tipo "some(X,Exp)" (pois é colocado um valor no início da lista, vide modelChecker1.pl). Entretanto, por que ele é essencial até mesmo para o procedimento ser compreendido?

    *Problemas sobre o modelChecker1*
    Os problemas 2, 3 e 4 relatados no livro não ocorrem comigo. Prolog retorna "false", e não "Not satisfied in model".


**Comentários**

O predicado "compose/3" conflita com o de um pacote do prolog-SWI. É necessário fazer consult("BB1/comsemPredicates.pl") diretamente.
