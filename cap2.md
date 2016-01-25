**Exercício 2.4.6** - **!**
Funciona "ignorando" o primeiro "lambda" (a primeira abstração), aplicando o resultado ao objeto (NP), (beta-reduzindo) e então re-colocando a primeira abstração.
Não consegui ver nenhum problema e parece funcionar. Entretanto, é uma operação um pouco distinta daquela de meramente realizar aplicações entre os componentes, uma vez que é feita uma aplicação com a parte interna de um dos componentes. (Será que isso tem algum efeito computacional negativo?)

**Exercício 2.4.8**
Esse programa cai em loop. Aplicar lam(x,app(x,x)) a si mesmo é fazer app(lam(x,app(x,x)),lam(x,app(x,x))). Beta-convertendo, cairemos exatamente na mesma expressão. Assim, executando isso, o programa rodará indefinidamente.

**Dúvidas**

*Seção 2.2*

 - Problemas do Experimento 1 e por que ocorrem:

-> [Relacionado a: exercício 2.2.1] Se tentar rodar experiment1.pl e executar
    ? - s([mia,likes,a,foot,massage],[]).
não obtemos o desejado, mas sim um erro:
    ERROR: arg/3: Type error: `compound' expected, found `mia' (an atom)

Aparentemente, tirar o arg de um atom não dá false, seguido do prolog realizando backtracking, mas sim dá esse erro, interrompendo a execução da query. Colocar a regra

    s(Sem)--> np(Sem), vp(SemVP), 
   {
    arg(1,SemVP,X),
    arg(1,Sem,X),
    arg(2,Sem,Matrix),
    arg(2,Matrix,SemVP)
   }.

após a outra regra

s(Sem)--> np(SemNP), vp(Sem), 
   {
    arg(1,Sem,SemNP)
   }.

funciona, o que é razoável pois o se tenta tirar um arg de Sem, onde np(Sem).

O texto não comenta nada sobre esse problema. Será que foi alguma mudança no comportamento de arg/3? Se sim, será que é arriscado dar algum problema futuro?

*Beta conversion com alpha conversion*

Não há risco de, por acaso, após a alpha conversion aparecer alguma variável idêntica a de outra fórmula em uma expressão maior (gerando o binding acidental que não queríamos)?
O que garante que não ocorre?

*phrase/3*
Converter uma string em uma lista (atom_codes). Daí, phrase(p(X), Codes, Rest) retorna o início da string tal que p(X) é true, X é a string (já reconvertida em string), Codes é a string (convertida em lista) inteira e Rest é o restante da string (ainda em forma de lista).
