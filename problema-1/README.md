# Problema 1 - Lucro de Plantação no Stardew Valley
Minhas anotações sobre o Problema 1 da Rinha de Algoritmos.

1. [Descrição do Problema](#descrição-do-problema)
1. [Minha Solução](#minha-solução)
1. [Como Rodar](#como-rodar)

## Descrição do Problema

Sejam $n \in \mathbb{N}$, $c \in \mathbb{N}$, $p: [n] \to \mathbb{N}$ e $v: [n] \to \mathbb{N}$. Os elementos de $[n] = \{0, 1, \ldots, n - 1\}$ representam objetos distintos, e as funções $p$ e $v$ associam a cada objeto um peso e um valor, respectivamente. Além disso, $c$ representa o limite de peso de uma mochila.

A cada subconjunto $S \subseteq [n]$ associamos os valores $P(S)$ e $V(S)$, definidos abaixo, que representam o peso e o valor dos objetos em $S$, respectivamente.
$$P(S) = \sum_{i \in S} p(i)$$
$$V(S) = \sum_{i \in S} v(i)$$

Dizemos que um subconjunto $S \subseteq [n]$ é **viável** quando o peso dos objetos de $S$ não ultrapassa $c$, ou seja:
$$P(S) \leq c$$

Dizemos que um subconjunto viável $S^*$ é **ótimo** quando o valor de seus objetos é maior do que o valor dos objetos de qualquer outro subconjunto viável, ou seja, quando para todo subconjunto viável $S$:
$$V(S^*) \geq V(S)$$

> **(Problema da Mochila)** Dados $n \in \mathbb{N}$, $c \in \mathbb{N}$, $p: [n] \to \mathbb{N}$ e $v: [n] \to \mathbb{N}$, encontrar um subconjunto ótimo $S^* \subseteq [n]$.

Em outras palavras, o Problema da Mochila consiste em encontrar um subconjunto de objetos que não ultrapasse o limite de peso da mochila, e que possua o maior valor possível.

O Problema 1 da Rinha de Algoritmos é uma forma do Problema da Mochila, com a seguinte interpretação dos dados:
- $n$ representa o número de sementes;
- os elementos de $[n]$ representam os diferentes tipos de sementes;
- $c$ representa a quantidade de espaços disponíveis;
- $p(i)$ representa a quantidade de espaços ocupados pela semente $i$;
- $v(i)$ representa o ganho recebido no final do período ao plantar a semente $i$.

## Minha Solução

Estrutura recursiva do problema + algoritmo...

## Como Rodar

### Pré-requisitos
- Um computador com Linux e arquitetura x64
- NASM
- GCC
- Make

### Como executar
Primeiro, execute o comando:
```
make
```

O executável será compilado na basta `bin`. Para executar com um arquivo `exemplo.txt`, basta executar o comando:
```
./bin/main exemplo.txt
```
