is_vocabulary :- write("Insert vocabulary"), read(Lista), member(X, Lista), [A, N] = X, atom(A), number(N), member([A, M], Lista), N = M.
