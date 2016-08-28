# Computational Semantics (Work in Progress)
Repository for Bachelor's Thesis (final project) in Applied Mathematics at Fundação Getulio Vargas, supervised by [Alexandre Rademaker] (http://arademaker.github.io/)

We work with Blackburn & Bos files, integrating with Wordnet and doing other exercises.

The thesis text is available at texto/tcc_gppassos.pdf

# Requirements

- Prolog (we use [Prolog SWI](http://www.swi-prolog.org/) )

One of:
- Prover9 and Mace4: available at https://www.cs.unm.edu/~mccune/mace4/
- Otter and Mace2: available at https://www.cs.unm.edu/~mccune/otter/

If you are using Otter and Mace2, please uncomment in `BB1/inferenceEngines.pl` the line
`inferenceEngines([mace2,otter]).`
and comment 
`inferenceEngines([mace4,prover9]).`

# Usage

Access `BB1` folder and from there call `prolog`. You'll probably want to use our modifications from `kellerStorage.pl`, `holeSemantics.pl`, `helpfulCurt.pl` or `helpfulCurtHole.pl`:

```bash
prolog
```
```prolog
[helpfulCurt.pl].
curt.
```

For an example, you can then type
```
A king loves a dying dragon
```
For using Prover9 and Mace4 instead of Otter and Mace2, modify `inferenceEngines.pl`.

# References

- [Representation and Inference for Natural Language by Patrick Blackburn & Johan Bos] (http://www.let.rug.nl/bos/comsem/book1.html)
