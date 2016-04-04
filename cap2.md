**Exercício 2.4.6** - **!**
Funciona "ignorando" o primeiro "lambda" (a primeira abstração), aplicando o resultado ao objeto (NP), (beta-reduzindo) e então re-colocando a primeira abstração.
Não consegui ver nenhum problema e parece funcionar. Entretanto, é uma operação um pouco distinta daquela de meramente realizar aplicações entre os componentes, uma vez que é feita uma aplicação com a parte interna de um dos componentes. (Será que isso tem algum efeito computacional negativo?)

**Exercício 2.4.8**
Esse programa cai em loop. Aplicar lam(x,app(x,x)) a si mesmo é fazer app(lam(x,app(x,x)),lam(x,app(x,x))). Beta-convertendo, cairemos exatamente na mesma expressão. Assim, executando isso, o programa rodará indefinidamente.

**Exercício 2.5.3**

- i) Léxico - Adicionar as palavras que faltam: `motorbike` e `on`.
`englishLexicon.pl`, adicionado:
    - `lexEntry(noun,[symbol:motorbike,syntax:[motorbike]]).`
    - `lexEntry(prep,[symbol:on,syntax:[on]]).`

- ii) Sintático - Em `englishGrammar.pl`, adicionamos:
`vp([coord:no,inf:Inf,num:Num,gap:[],sem:VP])--> %exercicio 2.5.3
   cop([inf:Inf,num:Num,sem:Cop]), 
   pp([sem:PP]), 
   {combine(vp:VP,[cop:Cop,pp:PP])}.`

- iii) Semântico - Em `semRulesLambda.pl`, adicionamos:
`combine(vp:app(A,lam(P,some(X,app(app(B,P),X)))),[cop:A,pp:B]).`

A motivação para esta fórmula é a seguinte: A estrutura semântica do verbo de ligação (copula) é de considerar dois objetos como iguais (pelo predicado de igualdade eq/2). Porém, `Vincent is in a restaurant` aponta apenas um objeto, Vincent, e afirma uma propriedade sobre ele (estar em um restaurante). O que queremos, então, é fazer com que `is in a restaurant` passe a ser um sintagma verbal (*verbal phrase* - *vp*), o que se associaria com uma propriedade. Em termos de lambda calculus, ser uma propriedade é ser algo da forma `lam(X,app(P,X))`. A propriedade que montaremos para `is in a restaurant` é, na realidade, aqui feita postulando a existência de algum outro objeto X que cumpra essa propriedade e identificar o sujeito com X. Ou seja, estamos lendo `Vincent is in a restaurant` como semanticamente idêntico a `Vincent is someone in a restaurant`, ou, descartando a idéia de ''pessoa'' de ''*someone*'', semanticamente idêntico a  `Vincent is something in a restaurant`. Daí, a propriedade que `is in a restaurant` passa a representar é ``ser igual a um objeto X tal que X está em um restaurante''.

Veja que, em outros casos (como no `combine(vp:app(A,B),[cop:A,np:B]).`), a aplicação é simplesmente feita do np ao verbo de ligação (cop). Aqui, nós transformamos `B`, que é nosso pp (*prepositional phrase*), em `lam(P,some(X,app(app(B,P),X)))`. No exemplo, `in a restaurant` é representado semanticamente por `lam(P,lam(Y,some(X,and(and(restaurant(X),in(Y,X)),app(P,Y)))))`. Após esta transformação, passa a ser `lam(P,some(Y,some(X,and(and(restaurant(X),in(Y,X)),app(P,Y)))))`. Agora, aplicando isto na formulação do `is` (que é a formulação de copula), ficamos com `lam(Z,some(Y,some(X,and(and(restaurant(X),in(Y,X)),eq(Z,Y)))))`. Note que essa fórmula final é da forma `lam(Z,app(P,Z)`, como exigimos de uma propriedade: basta aplicar isto a um np e teremos uma fórmula de FOL.

Apesar disso funcionar, tem um resultado curioso. A representação para `Vincent and Jules are in a restaurant.` fica `and(some(A,and(some(B,and(restaurant(B),in(A,B))),eq(vincent,A))),some(C,and(some(D,and(restaurant(D),in(C,D))),eq(jules,C))))`. Isto significa que Vincent e Jules podem estar em restaurantes diferentes e a frase seria verdadeira, o que não parece corresponder ao significado que atribuímos à frase. Por exemplo, `Os cavaleiros estão sobre um cavalo` ou `Os cavaleiros estão a um cavalo` dá a entender que estão sobre o mesmo cavalo, não que podem estar sobre cavalos diferentes. Neste caso, diríamos `Os cavaleiros estão a cavalo`, `Os cavaleiros estão a cavalos` ou mesmo `Os cavaleiros estão sobre cavalos`.




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
