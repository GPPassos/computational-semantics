- prologdb.5.pdf:
`The mm operator specifies that the second synset is a member meronym of the first synset.`
However, it doesn't seem so. In Prolog, using wn_mm.pl, wn_s.pl and wn_g.pl, the query
`Search = 'dog', s(Synset_id,_,Search,_,_,_), g(Synset_id,Gloss), mm(Synset_id,MmSense),findall(X,s(Mmsense,_,X,_,_,_),Meronyms)`

returns `Meronyms = [pack]` on one case. However, pack isn't a meronym of dog, but rather the other way around: a dog is a part of a pack!

`Search = 'pack', s(Synset_id,_,Search,_,_,_), g(Synset_id,Gloss), mm(Synset_id,MmSense),findall(X,s(Mmsense,_,X,_,_,_),Meronyms)`

The above query won't return `dog` in `Meronyms`.
