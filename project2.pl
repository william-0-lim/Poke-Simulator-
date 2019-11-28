% Project 2 CPSC312 Haskell
% Poke Simulator  
% TaeGyun Lim - 25983157
% Do Hoon Lee - 26404153
% Hyehwa (Jennifer) Lee - 88516265

% Level is fixed at 50, IVs are fixed at 31

% NB multiplies final stats by 1.1, ND multiplies final stats by 0.9 
% mypokemon can have four moves from the available moves
% Distribute 510 EVs to stats of your choice, maximum for each is 252. 
% mypokemon(Pokemon, NB, ND, Moveset, EV)


% 1. turn one of the players to computer:
% - randomly picks a pokemon and attacks

% 2. attack is different depending on types (all the possible types):
% - type_attack function

% 3. depending on the pokemon stats, its attack value will be different 
% dohoon you are going to do this 

% 4. test the cases of when you pick an option that is not listed 

% 5. Finalize and test for any bugs
% - different number is in, then it repeats

% DONE:
% If wrong number is entered, then it asks again until the right number is entered
% Option of Play with Computer and Play between users is implemented


:- use_module(library(random)).



play :-
	write("Welcome to our Pokemon Simulator"), nl,
    choose_option(Option),
    (Option = 1 -> play_computer()
    ;Option = 2 -> between_users()
    ;play()).

choose_option(Option) :-
    write("Please choose the battle mode"), nl,
    write("1: Play with computer, 2: Play between two users"), nl,
    read(ChosenOption),
    (ChosenOption = 1 -> Option is 1
    ;ChosenOption = 2 -> Option is 2
    ;write("You have chosen a wrong option. Please retry."), nl, choose_option(Option)).


play_computer() :-
    write("Pick one of the four options"), nl,
    player(Pokemon1),
    write("The Computer has choosen a random pokemon."), nl,
	random_computer_pick(Pokemon2),
	pokemon(Pokemon2, PokemonName2),
	write("The Computer has randomly choosen "), write(PokemonName2), nl,
	battle_start(Pokemon1, Pokemon2, computer).


between_users() :-
	write("First player: pick one of the four options"), nl,
	player(Pokemon1),
	write("Second player: pick one of the four options"), nl,
	player(Pokemon2),
	battle_start(Pokemon1, Pokemon2, users).



player(ThePokemon) :-
	write("1: Pikachu, 2: Charmander, 3: Bulbasaur, 4: Squirtle"), nl,
	read(Pokemon),
	(Pokemon = 1 -> ThePokemon is 25, write("You have chosen Pikachu."), nl
	;Pokemon = 2 -> ThePokemon is 4, write("You have chosen Charmander."), nl
	;Pokemon = 3 -> ThePokemon is 1, write("You have chosen Bulbasaur."), nl
	;Pokemon = 4 -> ThePokemon is 7, write("You have chosen Squirtle."), nl
	;write("You have chosen the number that is not in the list. Please try again."), nl, player(ThePokemon)).


battle_start(Pokemon1, Pokemon2, Option) :-
	pokemon_speed(Pokemon1, Speed1),
	pokemon_speed(Pokemon2, Speed2),
	pokemon_hp(Pokemon1, HP1),
	pokemon_hp(Pokemon2, HP2),
	pokemon(Pokemon1, PokemonName1),
	pokemon(Pokemon2, PokemonName2),
    (Option = users ->
	(Speed2 =< Speed1
	-> write("PLAYER 1's "),write(PokemonName1), write(" is faster. Therefore, "), write("PLAYER 1's "),write(PokemonName1), write(" starts."), nl, battle1(Pokemon1, HP1, Pokemon2, HP2)
	; write("PLAYER 2's "),write(PokemonName2), write(" is faster. Therefore, "), write("PLAYER 2's "),write(PokemonName2), write(" starts."), nl, battle2(Pokemon1, HP1, Pokemon2, HP2))
    ;Option = computer ->
    (Speed2 =< Speed1
	-> write("PLAYER's "), write(PokemonName1), write(" is faster. Therefore, "), write("PLAYER's "), write(PokemonName1), write(" starts."), nl, battle_computer1(Pokemon1, HP1, Pokemon2, HP2)
	;write("COMPUTER's "), write(PokemonName2), write(" is faster. Therefore, "), write("COMPUTER's "), write(PokemonName2), write(" starts."), nl, battle_computer2(Pokemon1, HP1, Pokemon2, HP2))
    ;write("")).


battle1(Pokemon1, HP1, Pokemon2, HP2) :-
	pokemon_skills(Pokemon1, "Player 1"),
    read(Skill1), nl,
    skill_has(Skill1, Damage1),
    hp_calculator(HP2, Damage1, HP2_after, "Player 2"),
    write("Player 2 has "),
    write(HP2_after),
    write(" left."),

	pokemon_skills(Pokemon2, "Player 2"),
	read(Skill2), nl,
	skill_has(Skill2, Damage2),
    hp_calculator(HP1, Damage2, HP1_after, "Player 1"),
	write("Player 1 has "),
	write(HP1_after),
	write(" left."),
    battle1(Pokemon1, HP1_after, Pokemon2, HP2_after).


battle2(Pokemon1, HP1, Pokemon2, HP2) :-

	pokemon_skills(Pokemon2, "Player 2"),
	read(Skill2), nl,
	skill_has(Skill2, Damage2),
    hp_calculator(HP1, Damage2, HP1_after, "Player 1"),
	write("Player 1 has "),
	write(HP1_after),
	write(" left."),

    pokemon_skills(Pokemon1, "Player 1"),
    read(Skill1), nl,
    skill_has(Skill1, Damage1),
    hp_calculator(HP2, Damage1, HP2_after, "Player 2"),
    write("Player 2 has "),
    write(HP2_after),
    write(" left."),

    battle2(Pokemon1, HP1_after, Pokemon2, HP2_after).



battle_computer1(Pokemon1, HP1, Pokemon2, HP2) :-
	pokemon_skills(Pokemon1, "Player"),
    read(Skill1), nl,
    skill_has(Skill1, Damage1),
    hp_calculator(HP2, Damage1, HP2_after, "Computer"),
    write("Computer has "), write(HP2_after), write(" left."),

    write("Now it is the computer's turn to attack."), nl,
    write("GENERATING ATTACK"), nl,
    random_move(Pokemon2, Skill2),
    pokemon(Pokemon2, PokemonName2),
    write(PokemonName2), write(" has used "), write(Skill2), nl,
    skill_has(Skill2, Damage2),
    hp_calculator(HP1, Damage2, HP1_after, "Player"),
    write("Player has "), write(HP1_after), write(" left."),

    battle_computer1(Pokemon1, HP1_after, Pokemon2, HP2_after).


battle_computer2(Pokemon1, HP1, Pokemon2, HP2) :-
    write("Computer attacks."), nl,
    write("GENERATING ATTACK"), nl,
    random_move(Pokemon2, Skill2),
    pokemon(Pokemon2, PokemonName2),
    write(PokemonName2), write(" has used "), write(Skill2), nl,
    skill_has(Skill2, Damage2),
    hp_calculator(HP1, Damage2, HP1_after, "Player"),
    write("Player has "), write(HP1_after), write(" left."),

	pokemon_skills(Pokemon1, "Player"),
    read(Skill1), nl,
    skill_has(Skill1, Damage1),
    hp_calculator(HP2, Damage1, HP2_after, "Computer"),
    write("Computer has "), write(HP2_after), write(" left."),
    
    battle_computer2(Pokemon1, HP1_after, Pokemon2, HP2_after).



hp_calculator(HP, Damage, HP_after, HP_of) :-
	HP_after is HP - Damage,
	(HP_after =< 0 -> 
    write(HP_of), write("'s"), write(" pokemon has died. The game ended."), fail
	; write("")).



pokemon_skills(Pokemon, User) :- 
    pokemon_has(Pokemon,ListSkills),
    pokemon(Pokemon,PokemonName),
    write("Please pick the skill you want to use."), nl,
    write(User), write("'s "),
	write(PokemonName),
    write(" has skills: "),
    write(ListSkills), nl.


% helper: random_computer_pick(pokemon_list)
random_computer_pick(X) :- 
	random_member(X,[25,4,1,7]).


% helper: random_move(pokemon,pokemon_move)
random_move(X,Y) :-
	(X = 25 -> random_member(Y,[thunder,tackle])
	; X = 4 -> random_member(Y,[ember,tackle])
	; X = 1 -> random_member(Y,[absorb,tackle])
	; X = 7 -> random_member(Y,[bubble,tackle])
	; write("")). 


% DATA ----------

pokemon_list([25,4,1,7]).
pokemon_types([n,g,f,e]).

pokemon(25,'Pikachu').
pokemon(4,'Charmander').
pokemon(1,'Bulbasaur').
pokemon(7,'Squirtle').

type(n,'Normal').
type(g,'Grass').
type(f,'Fire').
type(e,'Electric').
type(w,'Water').


% helper: pokemon_has(Pokemon_number, List_of_skills)
pokemon_has(25, ['thunder','tackle']).
pokemon_has(4, ['ember','tackle']).
pokemon_has(1,['absorb','tackle']).
pokemon_has(7,['bubble','tackle']).

% helper: pokemon_hp(Pokemon_number, HP)
pokemon_hp(25,100).
pokemon_hp(4,100).
pokemon_hp(1,100).
pokemon_hp(7,100).

% helper: skill_has(Skill, Damage)
skill_has(thunder, 70).
skill_has(absorb, 50).
skill_has(bubble,50).
skill_has(ember, 50).
skill_has(tackle, 40).

% helper: pokemon_speed(Pokemon, Speed)
pokemon_speed(25, X) :-
	random_between(85,95,X).
pokemon_speed(4, X) :-
	random_between(80,90,X).
pokemon_speed(1, X) :-
	random_between(75,85,X).
pokemon_speed(7, X) :-
	random_between(78,88,X).	


% helper: pokemon_type(Pokemon, Type)
pokemon_type(25, electric).
pokemon_type(4, fire).
pokemon_type(1, grass).
pokemon_type(7, water).


% helper: type_attack(Type1, Type2, Times)
% if Type1 attacks Type2, then by how many Times does the attack increase by
type_attack(electric, water, 2).
type_attack(fire, grass, 2).
type_attack(grass, water, 2).
type_attack(grass, fire, 0.5).
type_attack(fire, water, 0.5).

