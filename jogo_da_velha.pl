%%%%% Edeilson Carlos Messias - 15.1.5954
%%%%% Silvandro Sergio Martins Oliveira - 12.2.8233

inicio :- nl, write('Bem vindos ao jogo da velha UFOP!'), nl, infos, lerDimensao(N), criarTabuleiro(N, N, Tabuleiro), iniciarJogo(N, Tabuleiro).

infos :- nl, write('INSTRUÇÕES:'), nl, nl,
         write('1 - Inicialmente, informe o tamanho da matriz que represente o jogo com um número qualquer N seguido de um ponto e aperte Enter'), nl,
         write('2 - Em seguida, o programa irá solicitar que o Jogador 1 entre com um número qualquer N seguido de um ponto para representar o número da linha na matriz e aperte Enter'), nl,
         write('3 - Próximo passo, o programa irá solicitar que o Jogador 1 entre com um número qualquer N seguido de um ponto para representar o número da coluna na matriz e aperte Enter, e com isso a posição informada nos pontos 2 e 3 irão representar a jogada do Jogador 1'), nl,
         write('4 - Os pontos 2 e 3 serão repetidos para capturar a jogada do Jogador 2'), nl,
         write('5 - O primeiro jogador que conseguir completar uma linha, coluna ou diagonal apenas com seu respectivo símbolo, vencerá o jogo'), nl, nl, nl, nl.

% Ler a dimensão do jogo pelo usuário até que seja maior que zero
lerDimensao(N) :-
	repeat,
	write('Digite a dimensão do jogo, que deve ser maior que 0, seguido de um ponto e depois tecle Enter:'),
	nl, read(N), N > 0, !.

% Cria uma matriz NxN para representar o tabuleiro
criarTabuleiro(_, Linha, []) :- Linha=0,!.
criarTabuleiro(Dimensao, Linha, Tabuleiro) :-
	LinhaAux is Linha-1,
	criarLinha(Dimensao, Lista),
	insere(Lista, Matriz, Tabuleiro),
	criarTabuleiro(Dimensao, LinhaAux, Matriz).

% Cria a linha da matriz
criarLinha(Dimensao, []) :- Dimensao=0, !.
criarLinha(Dimensao, Linha) :- N is Dimensao-1, insere(0, LinhaAux, Linha), criarLinha(N, LinhaAux).
	
insere(Elem, Lista, [Elem|Lista]).

% Imprime o tabuleiro para o usuário
exibirTabuleiro(Dimensao, Tabuleiro) :-
	colunaTabuleiro(Dimensao),
	nl, linhaTabuleiro(1, Tabuleiro),
	colunaTabuleiro(Dimensao).

% Imprime as colunas do tabuleiro
colunaTabuleiro(Dimensao) :- tab(2), indiceColuna(0, Dimensao).

indiceColuna(_, Dimensao) :- Dimensao=0, !.
indiceColuna(Inicial, Dimensao) :-
	N is Dimensao-1,
	N1 is Inicial+1,
	imprimeIndiceColuna(N1),
	indiceColuna(N1, N).

imprimeIndiceColuna(Indice) :- Indice =< 10, tab(3), write(Indice).
imprimeIndiceColuna(Indice) :- Indice > 10, tab(2), write(Indice).

% Imprime as linhas do tabuleiro
linhaTabuleiro(_,[]).
linhaTabuleiro(Indice,[Cabeca|Cauda]):-
	imprimeLinha(Indice, Cabeca),
	N is Indice+1,
	linhaTabuleiro(N, Cauda).

imprimeLinha(Indice, Jogadas) :-
	imprimeIndiceLinha(Indice),
	write(' |'),
	jogadaLinha(Jogadas),
	imprimeIndiceLinha(Indice), nl.

imprimeIndiceLinha(Indice) :- Indice =< 10, tab(1), write(Indice).
imprimeIndiceLinha(Indice) :- Indice > 10, write(Indice).

% Imprime as jogadas realizadas no tabuleiro
jogadaLinha([]).
jogadaLinha([Cabeca|Cauda]):- imprimeJogada(Cabeca), jogadaLinha(Cauda).

imprimeJogada(0):- write('   |').
imprimeJogada(1):- write(' X |').
imprimeJogada(2):- write(' O |').

%Inicia o a partida
iniciarJogo(Dimensao, Tabuleiro) :-
	limparTela,
    infos,
	exibirTabuleiro(Dimensao, Tabuleiro),
	nl, nl, write('JOGADOR 1 - Digite a posição válida do Tabuleiro:'),
	realizarJogada(1, Dimensao, Tabuleiro, NovoTabuleiro),
	testarFimDeJogo(Dimensao, NovoTabuleiro, 1),
	limparTela,
    infos,
	exibirTabuleiro(Dimensao, NovoTabuleiro),
	nl, nl, write('JOGADOR 2 - Digite a posição válida do Tabuleiro:'),
	realizarJogada(2, Dimensao, NovoTabuleiro, NovoTabuleiro2),
	testarFimDeJogo(Dimensao, NovoTabuleiro2, 2),
	iniciarJogo(Dimensao, NovoTabuleiro2).

% Lê a jogada do usuário e atualiza o tabuleiro
realizarJogada(Jogador, Dimensao, Tabuleiro, NovoTabuleiro) :-
	lerJogada(Dimensao, Tabuleiro, Linha, Coluna),
	atualizarTabuleiro(Tabuleiro, Jogador, Linha, Coluna, NovoTabuleiro).

lerJogada(Dimensao, Tabuleiro, Linha, Coluna) :-
	repeat,
	nl, nl, write('Digite o número da LINHA, seguido de um ponto e depois tecle Enter:'), nl, read(Linha),
	nl, write('Digite o número da COLUNA, seguido de um ponto e depois tecle Enter:'), nl, read(Coluna), nl,
	Linha>0, Linha=<Dimensao, Coluna>0, Coluna=<Dimensao,
	valorPosicao(Tabuleiro, Linha, Coluna, Valor), Valor=0, !.

% Retorna o valor da posição Linha x Coluna enviados
valorPosicao(Tabuleiro, Linha, Coluna, Valor) :-
	buscarNaLinha(1, Linha, Tabuleiro, LinhaRetornada),
	buscarNaLinha(1, Coluna, LinhaRetornada, Valor).

% Busca a linha pelo índice
buscarNaLinha(Contador, Indice, [Cabeca|_], Cabeca):- Indice=Contador, !.
buscarNaLinha(Contador, Indice, [_|Cauda], Retorno):- N is Contador+1, buscarNaLinha(N, Indice, Cauda, Retorno).

%Atualiza jogada no tabuleiro
atualizarTabuleiro(Tabuleiro, Jogador, Linha, Coluna, NovoTabuleiro) :-
	buscarNaLinha(1, Linha, Tabuleiro, LinhaRetornada),
	atualizarPosicao(LinhaRetornada, Coluna, Jogador, NovaLinha),
	atualizarPosicao(Tabuleiro, Linha, NovaLinha, NovoTabuleiro), !.

atualizarPosicao([_|Cauda], 1, Jogador, [Jogador|Cauda]) :- !.
atualizarPosicao([Cabeca|Cauda], Posicao, Jogador, [Cabeca|Retorno]) :- N is Posicao-1, atualizarPosicao(Cauda, N, Jogador, Retorno).

% Verifica se o jogo terminou ou não
testarFimDeJogo(Dimensao, Tabuleiro, Jogador) :-
	verificaFimDeJogo(Dimensao, Tabuleiro, Jogador),
	exibirTabuleiro(Dimensao, Tabuleiro), nl, !, fail.
testarFimDeJogo(_,_,_).

verificaFimDeJogo(Dimensao, Tabuleiro, Jogador) :-
	fimDeJogoPorLinha(Dimensao, Tabuleiro, Jogador), imprimirGanhador(Jogador), !;
	fimDeJogoPorColuna(Dimensao, Tabuleiro, Jogador), imprimirGanhador(Jogador), !;
	fimDeJogoPorDiagonal(Dimensao, Tabuleiro, Jogador), imprimirGanhador(Jogador), !;
	fimDeJogoPorDiagonal2(Dimensao, Tabuleiro, Jogador), imprimirGanhador(Jogador), !;
	fimDeJogoPorVelha(Dimensao, Tabuleiro, Jogador), imprimirGanhador(0), !.

% Verifica se algúem venceu por completar uma linha
fimDeJogoPorLinha(Dimensao, Tabuleiro, Jogador) :- testarLinha(Dimensao, 1, Tabuleiro, Jogador).

testarLinha(_, Linha, Tabuleiro, Jogador) :- 
	buscarNaLinha(1, Linha, Tabuleiro, LinhaRetornada),
	testarValorLinha(Jogador, LinhaRetornada), !.

testarLinha(Dimensao, Linha, Tabuleiro, Jogador) :-
	Linha=<Dimensao, N is Linha+1,
	testarLinha(Dimensao, N, Tabuleiro, Jogador), !.

testarValorLinha(1, Linha) :- member(1, Linha), not(member(0, Linha)), not(member(2, Linha)).
testarValorLinha(2, Linha) :- member(2, Linha), not(member(0, Linha)), not(member(1, Linha)).

imprimirGanhador(0) :- limparTela, nl, write('O jogo terminou em empate. Digite a expressão "inicio." para começar novamente o jogo.'), nl, nl.
imprimirGanhador(1) :- limparTela, nl, write('Jogador 1 venceu. Digite a expressão "inicio." para começar novamente o jogo.'), nl, nl.
imprimirGanhador(2) :- limparTela, nl, write('Jogador 2 venceu. Digite a expressão "inicio." para começar novamente o jogo.'), nl, nl.

% Verifica se algúem venceu por completar uma coluna
fimDeJogoPorColuna(Dimensao, Tabuleiro, Jogador) :- testarColunas(Dimensao, Tabuleiro, 1, 1, Jogador), !.

testarColunas(Dimensao, Tabuleiro, Linha, Coluna, Jogador) :-
	Coluna=<Dimensao,
	N is Coluna+1,
	(not(testarColuna(Dimensao, Tabuleiro, Linha, Coluna, Jogador));
	testarColunas(Dimensao, Tabuleiro, Linha, N, Jogador)), !.

testarColuna(_, Tabuleiro, Linha, Coluna, Jogador) :- 
	valorPosicao(Tabuleiro, Linha, Coluna, Valor),
	Valor=\=Jogador, !.

testarColuna(Dimensao, Tabuleiro, Linha, Coluna, Jogador) :-
	Linha=<Dimensao,
	N is Linha+1,
	testarColuna(Dimensao, Tabuleiro, N, Coluna, Jogador).

% Verifica se algúem venceu por completar a diagonal principal
fimDeJogoPorDiagonal(Dimensao, Tabuleiro, Jogador) :- not(testarDiagonal(Dimensao, Tabuleiro, 1, 1, Jogador)), !.

testarDiagonal(_, Tabuleiro, Linha, Coluna, Jogador) :-
	valorPosicao(Tabuleiro, Linha, Coluna, Valor),
	testarValorColuna(Jogador, Valor), !.

testarDiagonal(Dimensao, Tabuleiro, Linha, Coluna, Jogador) :-
	Linha=<Dimensao, Coluna=<Dimensao,
	X is Linha+1, Y is Coluna+1,
	testarDiagonal(Dimensao, Tabuleiro, X, Y, Jogador).

testarValorColuna(1, Valor) :- (Valor=0; Valor=2).
testarValorColuna(2, Valor) :- (Valor=0; Valor=1).

% Verifica se algúem venceu por completar a diagonal secundária
fimDeJogoPorDiagonal2(Dimensao, Tabuleiro, Jogador) :- not(testarDiagonal2(Dimensao, Tabuleiro, 1, Dimensao, Jogador)), !.

testarDiagonal2(_, Tabuleiro, Linha, Coluna, Jogador) :-
	valorPosicao(Tabuleiro, Linha, Coluna, Valor),
	testarValorColuna(Jogador, Valor), !.

testarDiagonal2(Dimensao, Tabuleiro, Linha, Coluna, Jogador) :-
	Linha=<Dimensao, Coluna=<Dimensao,
	X is Linha+1, Y is Coluna-1,
	testarDiagonal2(Dimensao, Tabuleiro, X, Y, Jogador).

% Verifica se o jogo acabou por empate
fimDeJogoPorVelha(Dimensao, Tabuleiro, _) :- not(testarVelha(Dimensao, 1, Tabuleiro)), !.

testarVelha(_, Linha, Tabuleiro) :-
	buscarNaLinha(1, Linha, Tabuleiro, LinhaRetornada),
	member(0, LinhaRetornada), !.

testarVelha(Dimensao, Linha, Tabuleiro) :-
	Linha =< Dimensao,
	N is Linha+1,
	testarVelha(Dimensao, N, Tabuleiro), !.

% Limpa a tela do terminal
limparTela :- write('\e[H\e[2J').
